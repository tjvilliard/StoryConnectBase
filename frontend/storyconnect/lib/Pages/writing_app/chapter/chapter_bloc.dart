import 'package:bloc/bloc.dart';
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
  Map<int, String> pages;
  PageBloc pageBloc;
  AddChapter(
      {required super.callerIndex,
      required this.pages,
      required this.pageBloc});
}

class RemoveChapter extends ChapterEvent {
  RemoveChapter({required int callerIndex}) : super(callerIndex: callerIndex);
}

class ChapterBlocStruct {
  final int currentIndex;
  final Map<int, String> chapters;
  ChapterBlocStruct({required this.currentIndex, required this.chapters});
}

typedef ChapterEmitter = Emitter<ChapterBlocStruct>;

class ChapterBloc extends Bloc<ChapterEvent, ChapterBlocStruct> {
  ChapterBloc() : super(ChapterBlocStruct(currentIndex: 0, chapters: {0: ""})) {
    on<AddChapter>((event, emit) => addChapter(event, emit));
    on<RemoveChapter>((event, emit) => removeChapter(event, emit));
    on<SwitchChapter>((event, emit) => switchChapter(event, emit));
    on<UpdateChapter>((event, emit) => updateChapter(event, emit));
  }

  void addChapter(AddChapter event, ChapterEmitter emit) {
    Map<int, String> chapters = Map.from(state.chapters);
    final sortedChapterNum = chapters.keys.toList();
    sortedChapterNum.sort((b, a) => a.compareTo(b));
    final newChapterNum = sortedChapterNum.first + 1;

    chapters[event.callerIndex] = event.pages.values.join();
    chapters[newChapterNum] = "";

    emit(
      ChapterBlocStruct(
        currentIndex: newChapterNum,
        chapters: chapters,
      ),
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
      ),
    );
  }

  void switchChapter(SwitchChapter event, ChapterEmitter emit) {
    Map<int, String> chapters = Map.from(state.chapters);

    // combine the pages into a single string
    final String pageString = event.pages.values.join();
    chapters[event.chapterToSwitchFrom] = pageString;

    emit(
      ChapterBlocStruct(
        currentIndex: event.callerIndex,
        chapters: chapters,
      ),
    );
    event.pageBloc.add(RebuildPages(text: chapters[event.callerIndex] ?? ""));
  }

  void updateChapter(UpdateChapter event, Emitter<ChapterBlocStruct> emit) {
    Map<int, String> chapters = Map.from(state.chapters);
    chapters[event.callerIndex] = event.text;
    emit(
      ChapterBlocStruct(
        currentIndex: event.callerIndex,
        chapters: chapters,
      ),
    );
  }
}
