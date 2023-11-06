import 'dart:async';
import 'dart:convert';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:replay_bloc/replay_bloc.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/writing_app/components/feedback/state/feedback_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/pages_repository.dart';
import 'package:visual_editor/visual-editor.dart';
import 'package:synchronized/synchronized.dart';

part 'writing_state.dart';
part 'writing_bloc.freezed.dart';
part 'writing_events.dart';

typedef WritingEmitter = Emitter<WritingState>;

class WritingBloc extends Bloc<WritingEvent, WritingState>
    with ReplayBlocMixin<WritingEvent, WritingState> {
  static Lock writingLock = Lock();
  EditorController Function()? getEditorControllerCallback;
  Timer? debounceTimer;

  late final BookProviderRepository _repo;
  WritingBloc(BookProviderRepository repository)
      : super(WritingState.initial()) {
    _repo = repository;
    on<AddChapterEvent>(
      (event, emit) => addChapter(event, emit),
      transformer: sequential(),
    );
    on<RemoveChapterEvent>((event, emit) => removeChapter(event, emit),
        transformer: sequential());
    on<SwitchChapterEvent>((event, emit) => switchChapter(event, emit),
        transformer: sequential());
    on<UpdateChapterEvent>((event, emit) => updateChapter(event, emit),
        transformer: sequential());
    on<LoadWritingEvent>((event, emit) => loadWritingEvent(event, emit),
        transformer: sequential());
    on<WritingUndoCommandEvent>((event, emit) => undoCommand(event, emit));
    on<WritingRedoCommandEvent>((event, emit) => redoCommand(event, emit));

    on<_UpdateChapterHelperEvent>(
        (event, emit) => _updateChapterHelper(event.event, emit),
        transformer: sequential());
    on<SetEditorControllerCallbackEvent>(
        (event, emit) => setEditorControllerCallback(event, emit),
        transformer: sequential());
  }

  int get currentChapterId => state.chapterNumToID[state.currentIndex]!;

  Future<void> addChapter(AddChapterEvent event, WritingEmitter emit) async {
    emit.call(state.copyWith(
        loadingStruct: LoadingStruct.message("Creating Chapter")));

    Map<int, String> chapters = Map.from(state.chapters);

    final sortedChapterNum = chapters.keys.toList();
    sortedChapterNum.sort((b, a) => a.compareTo(b));
    final newChapterNum = sortedChapterNum.first + 1;
    final result = await _repo.createChapter(newChapterNum);
    if (result != null) {
      state.chapterNumToID[newChapterNum] = result.id;
      chapters[newChapterNum] = "";
      emit.call(state.copyWith(
          chapters: chapters, loadingStruct: LoadingStruct.loading(false)));
    } else {
      emit.call(state.copyWith(loadingStruct: LoadingStruct.loading(false)));
    }
  }

  void removeChapter(RemoveChapterEvent event, WritingEmitter emit) {
    Map<int, String> chapters = Map.from(state.chapters);
    chapters.remove(event.chapterNum);
    emit(
      state.copyWith(
          chapters: chapters, loadingStruct: LoadingStruct.loading(false)),
    );
  }

  DeltaDocM convertToDeltaDoc(String json) {
    DeltaDocM doc;
    try {
      doc = DeltaDocM.fromJson(jsonDecode(json));
    } catch (e) {
      print("Unable to convert to Delta doc, returning as blank chapter: $e");
      doc = DeltaDocM();
    }
    return doc;
  }

  void switchChapter(SwitchChapterEvent event, WritingEmitter emit) async {
    await writingLock.synchronized(() {
      final doc = convertToDeltaDoc(state.chapters[event.chapterToSwitchTo]!);

      final editor = getEditorControllerCallback?.call();
      emit(state.copyWith(
        currentIndex: event.chapterToSwitchTo,
      ));
      if (editor != null) {
        editor.update(doc.delta);
      }
    });
  }

  void updateChapter(UpdateChapterEvent event, WritingEmitter emit) async {
    await writingLock.synchronized(() async {
      if (debounceTimer != null && debounceTimer!.isActive) {
        debounceTimer!.cancel();
      }
      debounceTimer = Timer(Duration(milliseconds: 250), () {
        add(_UpdateChapterHelperEvent(event: event));
      });
    });
  }

  void _updateChapterHelper(
      UpdateChapterEvent event, WritingEmitter emit) async {
    await writingLock.synchronized(() async {
      Map<int, String> chapters = Map.from(state.chapters);
      chapters[event.chapterNum] = event.text;

      emit(state.copyWith(chapters: chapters));

      final chapterResult = await _repo.updateChapter(
        chapterId: state.chapterNumToID[event.chapterNum] ?? -1,
        number: event.chapterNum,
        text: chapters[event.chapterNum]!,
      );

      assert(chapterResult?.chapterContent == event.text);
    });
  }

  // helper function to load chapters into expected format
  _ParsedChapterResult _parseChapters(List<Chapter> chapters) {
    final Map<int, int> chapterNumToID = {};
    Map<int, String> parsedChapters = {};
    for (Chapter chapter in chapters) {
      chapterNumToID[chapter.number] = chapter.id;
      parsedChapters[chapter.number] = chapter.chapterContent;
    }
    return _ParsedChapterResult(
        chapters: parsedChapters, chapterNumToID: chapterNumToID);
  }

  void loadWritingEvent(LoadWritingEvent event, WritingEmitter emit) async {
    await writingLock.synchronized(() async {
      emit(
          state.copyWith(loadingStruct: LoadingStruct.message("Loading Book")));
      final unParsedChapters = await _repo.getChapters();
      final _ParsedChapterResult result = _parseChapters(unParsedChapters);
      print("we should only be calling this once");
      final doc = convertToDeltaDoc(result.chapters[0]!);
      final editor = getEditorControllerCallback?.call();
      if (editor != null) {
        editor.changes$.listen((event) async {
          await writingLock.synchronized(() {
            add(UpdateChapterEvent(
                chapterNum: state.currentIndex,
                text: jsonEncode(event.docDelta.toJson()),
                storeCommand: false));
          });
        });

        emit(state.copyWith(
            chapters: result.chapters,
            chapterNumToID: result.chapterNumToID,
            loadingStruct: LoadingStruct.loading(false)));
        clearHistory();

        final chapterId = state.chapterNumToID[state.currentIndex]!;
        event.feedbackBloc.add(LoadChapterFeedback(chapterId));
      }
    });
  }

  /// Undoes the last command. If the command is a switch chapter command, it will switch to the chapter that was switched from,
  /// and then perform the undo command. Multiple chapter switches in a row will be undone in reverse order.
  undoCommand(WritingUndoCommandEvent event, WritingEmitter emit) {
    undo();
  }

  redoCommand(WritingRedoCommandEvent event, WritingEmitter emit) {
    redo();
  }

  setEditorControllerCallback(
      SetEditorControllerCallbackEvent event, Emitter<WritingState> emit) {
    getEditorControllerCallback = event.callback;
  }
}
