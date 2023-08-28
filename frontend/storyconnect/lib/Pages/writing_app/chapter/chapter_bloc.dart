import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/material.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/writing_app/pages_repository.dart';

abstract class ChapterEvent {
  ChapterEvent();
}

class SwitchChapter extends ChapterEvent {
  int chaptertoSwitchFrom;
  int chapterToSwitchTo;
  SwitchChapter({
    required this.chaptertoSwitchFrom,
    required this.chapterToSwitchTo,
  });
}

class UpdateChapterEvent extends ChapterEvent {
  String text;
  TextSelection selection;
  UpdateChapterEvent({required this.text, required this.selection});
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

class ChapterBloc extends Bloc<ChapterEvent, ChapterBlocStruct> {
  final chapterNumToID = <int, int>{};
  final PagesProviderRepository repository;
  ChapterBloc(this.repository) : super(ChapterBlocStruct.initial()) {
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
  }

  Future<void> addChapter(AddChapter event, ChapterEmitter emit) async {
    emit.call(state.copyWith(
        loadingStruct: LoadingStruct.message("Creating Chapter")));

    Map<int, String> chapters = Map.from(state.chapters);

    final sortedChapterNum = chapters.keys.toList();
    sortedChapterNum.sort((b, a) => a.compareTo(b));
    final newChapterNum = sortedChapterNum.first + 1;
    print(state.loadingStruct.isLoading);
    final result = await repository.createChapter(newChapterNum);
    if (result != null) {
      chapterNumToID[newChapterNum] = result.id;
      chapters[newChapterNum] = "";
      emit.call(state.copyWith(
        chapters: chapters,
      ));
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
    Map<int, String> chapters = Map.from(state.chapters);
    // save current chapter
    print(chapters[event.chaptertoSwitchFrom]);

    emit(state.copyWith(
      currentIndex: event.chapterToSwitchTo,
    ));
  }

  void updateChapter(
      UpdateChapterEvent event, Emitter<ChapterBlocStruct> emit) async {
    Map<int, String> chapters = Map.from(state.chapters);
    chapters[state.currentIndex] = event.text;

    repository.updateChapter(
        chapterId: chapterNumToID[state.currentIndex] ?? -1,
        number: state.currentIndex,
        text: chapters[state.currentIndex]!);

    emit(state.copyWith(chapters: chapters));
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
    final unParsedChapters = await repository.getChapters();

    final chapters = parseChapters(unParsedChapters);
    emit(state.copyWith(
        chapters: chapters, loadingStruct: LoadingStruct.loading(false)));
  }
}
