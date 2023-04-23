import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:storyconnect/Models/loading_struct.dart';
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

class UpdateChapter extends ChapterEvent {
  final String text;
  UpdateChapter({required this.text, required int callerIndex})
      : super(callerIndex: callerIndex);
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChapterBlocStruct &&
        other.currentIndex == currentIndex &&
        _mapsAreEqual(other.chapters, chapters);
  }

  @override
  int get hashCode => currentIndex.hashCode ^ _mapHashCode(chapters);

  bool _mapsAreEqual(Map<int, String> a, Map<int, String> b) {
    if (a.length != b.length) return false;

    return a.entries.every((entry) {
      return b.containsKey(entry.key) && b[entry.key] == entry.value;
    });
  }

  int _mapHashCode(Map<int, String> map) {
    int hash = 0;

    map.forEach((key, value) {
      hash = hash ^ key.hashCode ^ value.hashCode;
    });

    return hash;
  }

  @override
  String toString() {
    return 'ChapterBlocStruct(currentIndex: $currentIndex, chapters: $chapters)';
  }
}

typedef ChapterEmitter = Emitter<ChapterBlocStruct>;

class ChapterBloc extends Bloc<ChapterEvent, ChapterBlocStruct> {
  final PagesProviderRepository repository;
  ChapterBloc(this.repository)
      : super(ChapterBlocStruct(
            currentIndex: 0,
            chapters: {0: ""},
            loadingStruct: LoadingStruct.loading(false))) {
    on<AddChapter>((event, emit) => addChapter(event, emit));
    on<RemoveChapter>(
      (event, emit) => removeChapter(event, emit),
      transformer: sequential(),
    );
    on<SwitchChapter>(
      (event, emit) => switchChapter(event, emit),
      transformer: sequential(),
    );
    on<UpdateChapter>((event, emit) => updateChapter(event, emit));
  }

  void addChapter(AddChapter event, ChapterEmitter emit) {
    Map<int, String> chapters = Map.from(state.chapters);
    final sortedChapterNum = chapters.keys.toList();
    sortedChapterNum.sort((b, a) => a.compareTo(b));
    final newChapterNum = sortedChapterNum.first + 1;

    chapters[event.callerIndex] = event.callerPages.values.join();
    chapters[newChapterNum] = "";

    emit(
      ChapterBlocStruct(
          currentIndex: newChapterNum,
          chapters: chapters,
          loadingStruct: LoadingStruct.loading(false)),
    );
    event.pageBloc.add(RebuildPages(text: ""));
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

  void switchChapter(SwitchChapter event, ChapterEmitter emit) {
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
  }

  void updateChapter(UpdateChapter event, Emitter<ChapterBlocStruct> emit) {
    Map<int, String> chapters = Map.from(state.chapters);
    chapters[event.callerIndex] = event.text;
    emit(
      ChapterBlocStruct(
        currentIndex: event.callerIndex,
        chapters: chapters,
        loadingStruct: LoadingStruct.loading(false),
      ),
    );
  }
}
