import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/state/feedback_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/reading_pages_repository.dart';
import 'package:synchronized/synchronized.dart';
import 'package:visual_editor/controller/controllers/editor-controller.dart';
import 'package:visual_editor/doc-tree/models/vertical-spacing.model.dart';
import 'package:visual_editor/document/models/delta-doc.model.dart';
import 'package:visual_editor/editor/models/editor-cfg.model.dart';
import 'package:visual_editor/styles/models/cfg/editor-styles.model.dart';
import 'package:visual_editor/styles/models/doc-tree/text-block-style.model.dart';

part 'reading_events.dart';
part 'reading_state.dart';
part 'reading_bloc.freezed.dart';

typedef ReadingEmitter = Emitter<ReadingState>;

class ReadingBloc extends Bloc<ReadingEvent, ReadingState> {
  static Lock readingLock = Lock();
  EditorController? Function()? getEditorControllerCallback;
  Timer? debounceTimer;
  StreamSubscription? editorSubscription;

  late final BookProviderRepository _repo;
  ReadingBloc(BookProviderRepository repo) : super(ReadingState.initial()) {
    _repo = repo;

    on<LoadReadingEvent>((event, emit) => loadReadingEvent(event, emit));
    on<SetEditorControllerCallbackEvent>(
        (event, emit) => setEditorControllerCallback(event, emit));
    on<SwitchChapterEvent>((event, emit) => switchChapter(event, emit));
  }

  int getSelectionBaseOffset() {
    final editor = getEditorControllerCallback?.call();
    return editor!.selection.baseOffset;
  }

  int getSelectionOffsetExtent() {
    final editor = getEditorControllerCallback?.call();
    return editor!.selection.extentOffset;
  }

  String getSelection() {
    final editor = getEditorControllerCallback?.call();
    return editor!.plainText.text
        .substring(editor.selection.baseOffset, editor.selection.extentOffset);
  }

  void loadReadingEvent(LoadReadingEvent event, ReadingEmitter emit) async {
    emit(state.copyWith(loadingStruct: LoadingStruct.message("Loading Book")));
    final List<Chapter> unParsedChapters = await _repo.getChapters();
    final _ParsedChapterResult result = _parseChapters(unParsedChapters);
    final editor = getEditorControllerCallback?.call();
    int index =
        event.chapterIndex > unParsedChapters.length ? 0 : event.chapterIndex;
    if (editor != null) {
      await editorSubscription?.cancel();

      final doc = convertToDeltaDoc(result.chapters[index]!);

      editor.update(doc.delta);
    }

    emit(state.copyWith(
        currentIndex: index,
        chapters: result.chapters,
        chapterNumToID: result.chapterNumToID,
        chapterIDToTitle: result.chapterIDToTitle,
        loadingStruct: LoadingStruct.loading(false)));

    final chapterId = state.chapterNumToID[index]!;
    if (kDebugMode) {
      print("Getting Feedback Event on Load Reading Event. ");
    }
    event.feedbackBloc.add(LoadChapterFeedbackEvent(chapterId: chapterId));
  }

  // helper function to load chapters into expected format
  _ParsedChapterResult _parseChapters(List<Chapter> chapters) {
    final Map<int, int> chapterNumToID = {};
    Map<int, String> parsedChapters = {};
    final Map<int, String?> chapterIDToTitle = {};
    for (Chapter chapter in chapters) {
      chapterNumToID[chapter.number] = chapter.id;
      parsedChapters[chapter.number] = chapter.chapterContent;
      chapterIDToTitle[chapter.id] = chapter.chapterTitle;
    }
    return _ParsedChapterResult(
        chapters: parsedChapters,
        chapterNumToID: chapterNumToID,
        chapterIDToTitle: chapterIDToTitle);
  }

  void switchChapter(SwitchChapterEvent event, ReadingEmitter emit) async {
    final doc = convertToDeltaDoc(state.chapters[event.chapterToSwitchTo]!);

    final editor = getEditorControllerCallback?.call();
    editorSubscription?.cancel();
    emit(state.copyWith(
      currentIndex: event.chapterToSwitchTo,
    ));
    if (editor != null) {
      await editorSubscription?.cancel();
      editor.update(doc.delta);
    }
  }

  DeltaDocM convertToDeltaDoc(String json) {
    DeltaDocM doc;
    try {
      doc = DeltaDocM.fromJson(jsonDecode(json));
    } catch (e) {
      // print("Unable to convert to Delta doc, returning as blank chapter: $e");
      doc = DeltaDocM();
    }
    return doc;
  }

  void setEditorControllerCallback(
      SetEditorControllerCallbackEvent event, ReadingEmitter emit) {
    getEditorControllerCallback = event.callback;
  }
}
