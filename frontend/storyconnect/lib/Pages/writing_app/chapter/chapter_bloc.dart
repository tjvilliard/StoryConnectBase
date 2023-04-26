import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/writing_app/pages_repository.dart';
import 'package:storyconnect/Pages/writing_app/writing/page_bloc.dart';

abstract class ChapterEvent {
  int callerIndex;

  ChapterEvent({required this.callerIndex});
}

class SwitchChapter extends ChapterEvent {
  int chapterToSwitchFrom;
  Map<int, String> pages;
  PageBloc pageBloc;
  SwitchChapter(
      {required super.callerIndex,
      required this.chapterToSwitchFrom,
      required this.pages,
      required this.pageBloc});
}

class UpdateChapterEvent extends ChapterEvent {
  final PageBloc pageBloc;
  UpdateChapterEvent({
    required this.pageBloc,
  }) : super(callerIndex: 0);
}

class LoadEvent extends ChapterEvent {
  PageBloc pageBloc;

  LoadEvent({required this.pageBloc}) : super(callerIndex: 0);
}

class AddChapter extends ChapterEvent {
  Map<int, String> callerPages;
  PageBloc pageBloc;
  AddChapter(
      {required super.callerIndex,
      required this.callerPages,
      required this.pageBloc});
}

class RemoveChapter extends ChapterEvent {
  RemoveChapter({required int callerIndex}) : super(callerIndex: callerIndex);
}

class ChapterBlocStruct {
  final int currentIndex;
  final Map<int, String> chapters;
  final LoadingStruct loadingStruct;

  ChapterBlocStruct(
      {required this.currentIndex,
      required this.chapters,
      required this.loadingStruct});

  ChapterBlocStruct copyWith({
    int? currentIndex,
    Map<int, String>? chapters,
    LoadingStruct? loadingStruct,
  }) {
    return ChapterBlocStruct(
      currentIndex: currentIndex ?? this.currentIndex,
      chapters: chapters ?? this.chapters,
      loadingStruct: loadingStruct ?? this.loadingStruct,
    );
  }
}

typedef ChapterEmitter = Emitter<ChapterBlocStruct>;

class ChapterBloc extends Bloc<ChapterEvent, ChapterBlocStruct> {
  final chapterNumToID = <int, int>{};
  final PagesProviderRepository repository;
  ChapterBloc(this.repository)
      : super(ChapterBlocStruct(
            currentIndex: 0,
            chapters: {0: ""},
            loadingStruct: LoadingStruct.loading(false))) {
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
      chapters[event.callerIndex] = event.callerPages.values.join();
      chapters[newChapterNum] = "";
      emit.call(ChapterBlocStruct(
          currentIndex: newChapterNum,
          chapters: chapters,
          loadingStruct: LoadingStruct.loading(false)));
      event.pageBloc.add(RebuildPages(text: ""));
    } else {
      emit.call(state.copyWith(loadingStruct: LoadingStruct.loading(false)));
    }
  }

  void removeChapter(ChapterEvent event, ChapterEmitter emit) {
    Map<int, String> chapters = Map.from(state.chapters);
    chapters.remove(event.callerIndex);
    emit(
      ChapterBlocStruct(
          currentIndex: event.callerIndex,
          chapters: chapters,
          loadingStruct: LoadingStruct.loading(false)),
    );
  }

  void switchChapter(SwitchChapter event, ChapterEmitter emit) async {
    Map<int, String> chapters = Map.from(state.chapters);
    // combine the pages into a single string
    final String pageString = event.pages.values.join();

    chapters[event.chapterToSwitchFrom] = pageString;
    event.pageBloc
        .add(RebuildPages(text: state.chapters[event.callerIndex] ?? ""));
    emit(
      ChapterBlocStruct(
          currentIndex: event.callerIndex,
          chapters: chapters,
          loadingStruct: LoadingStruct.loading(false)),
    );

    await repository.updateChapter(
        chapterId: chapterNumToID[event.chapterToSwitchFrom]!,
        number: event.chapterToSwitchFrom,
        text: pageString);
  }

  void updateChapter(
      UpdateChapterEvent event, Emitter<ChapterBlocStruct> emit) async {
    Map<int, String> chapters = Map.from(state.chapters);
    chapters[state.currentIndex] = event.pageBloc.state.pages.values.join();

    await repository.updateChapter(
        chapterId: chapterNumToID[state.currentIndex]!,
        number: state.currentIndex,
        text: chapters[state.currentIndex]!);
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
    event.pageBloc.add(RebuildPages(text: chapters[0] ?? ""));
  }
}
