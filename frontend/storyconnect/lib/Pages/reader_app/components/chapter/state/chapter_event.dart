part of 'chapter_bloc.dart';

abstract class ChapterEvent extends ReplayEvent {
  ChapterEvent();
}

class SwitchChapter extends ChapterEvent {
  int chapterToSwitchFrom;
  int chapterToSwitchTo;
  bool storeCommand;
  SwitchChapter({
    required this.chapterToSwitchFrom,
    required this.chapterToSwitchTo,
    this.storeCommand = true,
  });
}

/// Wrapper Event for the simple operation of switching to the next
/// sequential chapter.
class IncrementChapterEvent extends SwitchChapter {
  final int currentChapter;

  IncrementChapterEvent({required this.currentChapter})
      : super(
            chapterToSwitchFrom: currentChapter,
            chapterToSwitchTo: currentChapter + 1,
            storeCommand: false);
}

/// Wrapper Event for the simple operation of switching to the
/// previous sequential chapter.
class DecrementChapterEvent extends SwitchChapter {
  final int currentChapter;

  DecrementChapterEvent({required this.currentChapter})
      : super(
            chapterToSwitchFrom: currentChapter,
            chapterToSwitchTo: currentChapter - 1,
            storeCommand: false);
}

class LoadEvent extends ChapterEvent {
  LoadEvent();
}
