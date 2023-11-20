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

class WritingBloc extends Bloc<WritingEvent, WritingState> with ReplayBlocMixin<WritingEvent, WritingState> {
  static Lock writingLock = Lock();
  EditorController? Function()? getEditorControllerCallback;
  Timer? debounceTimer;
  StreamSubscription? editorSubscription;

  late final BookProviderRepository _repo;
  WritingBloc(BookProviderRepository repository) : super(WritingState.initial()) {
    _repo = repository;
    on<AddChapterEvent>(
      (event, emit) => addChapter(event, emit),
      transformer: sequential(),
    );
    on<RemoveChapterEvent>((event, emit) => removeChapter(event, emit), transformer: sequential());
    on<SwitchChapterEvent>((event, emit) => switchChapter(event, emit), transformer: sequential());
    on<UpdateChapterEvent>((event, emit) => updateChapter(event, emit), transformer: sequential());
    on<LoadWritingEvent>((event, emit) => loadWritingEvent(event, emit), transformer: sequential());
    on<WritingUndoCommandEvent>((event, emit) => undoCommand(event, emit));
    on<WritingRedoCommandEvent>((event, emit) => redoCommand(event, emit));
    on<UpdateChapterTitleEvent>((event, emit) => updateChapterTitle(event, emit), transformer: sequential());
    on<_UpdateChapterHelperEvent>((event, emit) => _updateChapterHelper(event.event, emit), transformer: sequential());
    on<SetEditorControllerCallbackEvent>((event, emit) => setEditorControllerCallback(event, emit),
        transformer: sequential());

    on<DeleteChapterEvent>((event, emit) => deleteChapter(event, emit), transformer: sequential());
  }

  int get currentChapterId => state.chapterNumToID[state.currentIndex]!;

  Future<void> addChapter(AddChapterEvent event, WritingEmitter emit) async {
    emit.call(state.copyWith(loadingStruct: LoadingStruct.message("Creating Chapter")));

    Map<int, String> chapters = Map.from(state.chapters);

    final sortedChapterNum = chapters.keys.toList();
    sortedChapterNum.sort((b, a) => a.compareTo(b));
    final newChapterNum = sortedChapterNum.first + 1;
    final result = await _repo.createChapter(newChapterNum);
    if (result != null) {
      final Map<int, int> chapterNumToID = Map<int, int>.from(state.chapterNumToID);
      chapterNumToID[newChapterNum] = result.id;
      chapters[newChapterNum] = "";
      emit.call(state.copyWith(
          chapterNumToID: chapterNumToID, chapters: chapters, loadingStruct: LoadingStruct.loading(false)));
    } else {
      emit.call(state.copyWith(loadingStruct: LoadingStruct.loading(false)));
    }
  }

  void removeChapter(RemoveChapterEvent event, WritingEmitter emit) {
    Map<int, String> chapters = Map.from(state.chapters);
    chapters.remove(event.chapterNum);
    emit(
      state.copyWith(chapters: chapters, loadingStruct: LoadingStruct.loading(false)),
    );
  }

  DeltaDocM convertToDeltaDoc(String json) {
    DeltaDocM doc;
    try {
      if (json.isEmpty) {
        doc = DeltaDocM();
      } else {
        doc = DeltaDocM.fromJson(jsonDecode(json));
      }
    } catch (e) {
      /// this feels really hacky, but it should work
      try {
        Map<String, String> intermediateJson = {"insert": "$json\n"};

        final finalizedJson = jsonEncode([intermediateJson]);
        final decodedJson = jsonDecode(finalizedJson);
        doc = DeltaDocM.fromJson(decodedJson);
        print("converted json to new format");
      } catch (e) {
        print("Unable to parse json, nor manually convert to new format. Returning as a blank chapter");
        doc = DeltaDocM();
      }
    }
    return doc;
  }

  void switchChapter(SwitchChapterEvent event, WritingEmitter emit) async {
    final doc = convertToDeltaDoc(state.chapters[event.chapterToSwitchTo]!);

    final editor = getEditorControllerCallback?.call();
    editorSubscription?.cancel();
    emit(state.copyWith(
      currentIndex: event.chapterToSwitchTo,
    ));
    if (editor != null) {
      await editorSubscription?.cancel();
      editor.update(doc.delta);
      editorSubscription = editor.changes$.listen((docEvent) async {
        await writingLock.synchronized(() {
          add(UpdateChapterEvent(
              chapterNum: event.chapterToSwitchTo, text: jsonEncode(docEvent.docDelta.toJson()), storeCommand: false));
        });
      });
    }
  }

  void updateChapter(UpdateChapterEvent event, WritingEmitter emit) async {
    if (debounceTimer != null && debounceTimer!.isActive) {
      debounceTimer!.cancel();
    }
    debounceTimer = Timer(Duration(milliseconds: 250), () {
      add(_UpdateChapterHelperEvent(event: event));
    });
  }

  void _updateChapterHelper(UpdateChapterEvent event, WritingEmitter emit) async {
    Map<int, String> chapters = Map.from(state.chapters);
    chapters[event.chapterNum] = event.text;

    final doc = DeltaDocM.fromJson(jsonDecode(event.text));
    // temporary editor to get the plain text

    final EditorController editor = EditorController(document: doc);
    final String plainText = editor.plainText.text;

    emit(state.copyWith(chapters: chapters));

    final chapterResult = await _repo.updateChapter(
      chapterId: state.chapterNumToID[event.chapterNum] ?? -1,
      number: event.chapterNum,
      content: chapters[event.chapterNum]!,
      rawContent: plainText,
    );

    assert(chapterResult?.chapterContent == event.text);
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
        chapters: parsedChapters, chapterNumToID: chapterNumToID, chapterIDToTitle: chapterIDToTitle);
  }

  void loadWritingEvent(LoadWritingEvent event, WritingEmitter emit) async {
    emit(state.copyWith(loadingStruct: LoadingStruct.message("Loading Book")));
    final unParsedChapters = await _repo.getChapters();
    final _ParsedChapterResult result = _parseChapters(unParsedChapters);
    final editor = getEditorControllerCallback?.call();
    if (editor != null) {
      await editorSubscription?.cancel();

      final doc = convertToDeltaDoc(result.chapters[0]!);
      editor.update(doc.delta);
      editorSubscription = editor.changes$.listen((event) async {
        await writingLock.synchronized(() {
          add(UpdateChapterEvent(chapterNum: 0, text: jsonEncode(event.docDelta.toJson()), storeCommand: false));
        });
      });

      emit(state.copyWith(
          chapters: result.chapters,
          chapterNumToID: result.chapterNumToID,
          chapterIDToTitle: result.chapterIDToTitle,
          loadingStruct: LoadingStruct.loading(false)));
      clearHistory();

      final chapterId = state.chapterNumToID[state.currentIndex]!;
      event.feedbackBloc.add(LoadChapterFeedback(chapterId));
    }
  }

  /// Undoes the last command. If the command is a switch chapter command, it will switch to the chapter that was switched from,
  /// and then perform the undo command. Multiple chapter switches in a row will be undone in reverse order.
  void undoCommand(WritingUndoCommandEvent event, WritingEmitter emit) {
    undo();
  }

  void redoCommand(WritingRedoCommandEvent event, WritingEmitter emit) {
    redo();
  }

  void setEditorControllerCallback(SetEditorControllerCallbackEvent event, WritingEmitter emit) {
    getEditorControllerCallback = event.callback;
  }

  void updateChapterTitle(UpdateChapterTitleEvent event, WritingEmitter emit) async {
    final chapterId = state.chapterNumToID[event.chapterNum]!;
    Map<int, String> chapters = Map.from(state.chapters);

    final String chapterContent = chapters[event.chapterNum] ?? "";

    String plainText = "";
    if (chapterContent.isNotEmpty) {
      final doc = DeltaDocM.fromJson(jsonDecode(chapterContent));
      // temporary editor to get the plain text

      final EditorController editor = EditorController(document: doc);
      plainText = editor.plainText.text;
    }

    final chapterResult = await _repo.updateChapterTitle(
      chapterId: chapterId,
      number: event.chapterNum,
      content: chapterContent,
      title: event.title,
      rawContent: plainText,
    );

    if (chapterResult) {
      final chapterTitles = Map<int, String?>.from(state.chapterIDToTitle);
      chapterTitles[chapterId] = event.title;
      emit(state.copyWith(chapterIDToTitle: chapterTitles));
    }
  }

  void deleteChapter(DeleteChapterEvent event, WritingEmitter emit) async {
    final chapterId = state.chapterNumToID[event.chapterNum];
    if (chapterId == null) {
      // Handle the case where the chapter number does not exist.
      return;
    }

    final deleteResult = await _repo.deleteChapter(chapterId);
    if (!deleteResult) {
      // Handle the failure case of chapter deletion.
      return;
    }

    final chapterNumToID = Map<int, int>.from(state.chapterNumToID)..remove(event.chapterNum);
    final chapters = Map<int, String>.from(state.chapters)..remove(event.chapterNum);
    final chapterIDToTitle = Map<int, String?>.from(state.chapterIDToTitle)..remove(chapterId);

    // Iteratively update the chapter numbers locally only
    for (int i = event.chapterNum + 1; i <= state.chapters.length; i++) {
      final nextChapterId = chapterNumToID[i];
      if (nextChapterId != null) {
        chapterNumToID[i - 1] = nextChapterId;
        chapters[i - 1] = chapters[i]!;
        chapterIDToTitle[nextChapterId] = chapterIDToTitle[nextChapterId];
      }
    }

    // Remove the last chapter's data as it has been shifted up
    chapterNumToID.remove(state.chapters.length - 1);
    chapters.remove(state.chapters.length - 1);
    chapterIDToTitle.remove(chapterId);

    emit(state.copyWith(chapterNumToID: chapterNumToID, chapters: chapters, chapterIDToTitle: chapterIDToTitle));
  }
}
