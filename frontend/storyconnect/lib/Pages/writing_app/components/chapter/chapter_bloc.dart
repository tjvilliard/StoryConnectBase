import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/material.dart';
import 'package:replay_bloc/replay_bloc.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/writing_app/components/pages_repository.dart';

abstract class ChapterEvent extends ReplayEvent {
  ChapterEvent();
}

class SwitchChapter extends ChapterEvent {
  int chaptertoSwitchFrom;
  int chapterToSwitchTo;
  bool storeCommand;
  SwitchChapter({
    required this.chaptertoSwitchFrom,
    required this.chapterToSwitchTo,
    this.storeCommand = true,
  });
}

class UpdateChapterEvent extends ChapterEvent {
  String text;
  TextSelection selection;
  bool storeCommand;
  UpdateChapterEvent({
    required this.text,
    required this.selection,
    this.storeCommand = true,
  });
}

class LoadEvent extends ChapterEvent {
  LoadEvent();
}

class AddChapter extends ChapterEvent {
  AddChapter();
}

class RemoveChapter extends ChapterEvent {
  int chapterNum;
  RemoveChapter({required this.chapterNum});
}

class UndoCommand extends ChapterEvent {
  UndoCommand();
}

class RedoCommand extends ChapterEvent {
  RedoCommand();
}

class _UpdateChapterHelperEvent extends ChapterEvent {
  UpdateChapterEvent event;
  _UpdateChapterHelperEvent({required this.event});
}

class ChapterBlocStruct {
  final int currentIndex;
  final Map<int, String> chapters;
  final LoadingStruct loadingStruct;
  final int? caretOffset;

  ChapterBlocStruct({
    required this.currentIndex,
    required this.chapters,
    required this.loadingStruct,
    this.caretOffset,
  });

  ChapterBlocStruct copyWith({
    int? currentIndex,
    Map<int, String>? chapters,
    LoadingStruct? loadingStruct,
    int? caretOffset,
  }) {
    return ChapterBlocStruct(
      currentIndex: currentIndex ?? this.currentIndex,
      chapters: chapters ?? this.chapters,
      loadingStruct: loadingStruct ?? this.loadingStruct,
      caretOffset: caretOffset ?? this.caretOffset,
    );
  }

  // initial constructor
  factory ChapterBlocStruct.initial() {
    return ChapterBlocStruct(
        currentIndex: 0,
        chapters: {0: ""},
        loadingStruct: LoadingStruct.loading(false));
  }
}

typedef ChapterEmitter = Emitter<ChapterBlocStruct>;

class ChapterBloc extends Bloc<ChapterEvent, ChapterBlocStruct>
    with ReplayBlocMixin<ChapterEvent, ChapterBlocStruct> {
  Timer? debounceTimer;

  final chapterNumToID = <int, int>{};

  late final BookProviderRepository _repo;
  ChapterBloc(BookProviderRepository repository)
      : super(ChapterBlocStruct.initial()) {
    _repo = repository;
    on<AddChapter>(
      (event, emit) => addChapter(event, emit),
      transformer: sequential(),
    );
    on<RemoveChapter>(
      (event, emit) => removeChapter(event, emit),
    );
    on<SwitchChapter>(
      (event, emit) => switchChapter(event, emit),
    );
    on<UpdateChapterEvent>((event, emit) => updateChapter(event, emit),
        transformer: sequential());

    on<LoadEvent>((event, emit) => loadEvent(event, emit));

    on<UndoCommand>((event, emit) => undoCommand(event, emit));
    on<RedoCommand>((event, emit) => redoCommand(event, emit));

    on<_UpdateChapterHelperEvent>(
        (event, emit) => _updateChapterHelper(event.event, emit));
  }

  Future<void> addChapter(AddChapter event, ChapterEmitter emit) async {
    emit.call(state.copyWith(
        loadingStruct: LoadingStruct.message("Creating Chapter")));

    Map<int, String> chapters = Map.from(state.chapters);

    final sortedChapterNum = chapters.keys.toList();
    sortedChapterNum.sort((b, a) => a.compareTo(b));
    final newChapterNum = sortedChapterNum.first + 1;
    print(state.loadingStruct.isLoading);
    final result = await _repo.createChapter(newChapterNum);
    if (result != null) {
      chapterNumToID[newChapterNum] = result.id;
      chapters[newChapterNum] = "";
      emit.call(state.copyWith(
          chapters: chapters, loadingStruct: LoadingStruct.loading(false)));
    } else {
      emit.call(state.copyWith(loadingStruct: LoadingStruct.loading(false)));
    }
  }

  void removeChapter(RemoveChapter event, ChapterEmitter emit) {
    Map<int, String> chapters = Map.from(state.chapters);
    chapters.remove(event.chapterNum);
    emit(
      state.copyWith(
          chapters: chapters, loadingStruct: LoadingStruct.loading(false)),
    );
  }

  void switchChapter(SwitchChapter event, ChapterEmitter emit) async {
    emit(state.copyWith(
      currentIndex: event.chapterToSwitchTo,
    ));
  }

  void updateChapter(
      UpdateChapterEvent event, Emitter<ChapterBlocStruct> emit) async {
    if (debounceTimer != null && debounceTimer!.isActive) {
      debounceTimer!.cancel();
    }
    debounceTimer = Timer(Duration(milliseconds: 250), () {
      add(_UpdateChapterHelperEvent(event: event));
    });
  }

  void _updateChapterHelper(
      UpdateChapterEvent event, Emitter<ChapterBlocStruct> emit) async {
    Map<int, String> chapters = Map.from(state.chapters);
    chapters[state.currentIndex] = event.text;

    emit(state.copyWith(chapters: chapters));

    _repo.updateChapter(
      chapterId: chapterNumToID[state.currentIndex] ?? -1,
      number: state.currentIndex,
      text: chapters[state.currentIndex]!,
    );
  }

  // helper function to load chapters into expected format
  Map<int, String> parseChapters(List<Chapter> chapters) {
    Map<int, String> parsedChapters = {};
    for (Chapter chapter in chapters) {
      chapterNumToID[chapter.number] = chapter.id;
      parsedChapters[chapter.number] = chapter.chapterContent;
    }
    return parsedChapters;
  }

  void loadEvent(LoadEvent event, Emitter<ChapterBlocStruct> emit) async {
    emit(state.copyWith(loadingStruct: LoadingStruct.message("Loading Book")));
    final unParsedChapters = await _repo.getChapters();

    final chapters = parseChapters(unParsedChapters);

    emit(state.copyWith(
        chapters: chapters, loadingStruct: LoadingStruct.loading(false)));
    clearHistory();
  }

  /// Undoes the last command. If the command is a switch chapter command, it will switch to the chapter that was switched from,
  /// and then perform the undo command. Multiple chapter switches in a row will be undone in reverse order.
  undoCommand(UndoCommand event, Emitter<ChapterBlocStruct> emit) {
    undo();
  }

  redoCommand(RedoCommand event, Emitter<ChapterBlocStruct> emit) {
    redo();
  }
}
