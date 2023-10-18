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

class LoadEvent extends ChapterEvent {
  LoadEvent();
}
