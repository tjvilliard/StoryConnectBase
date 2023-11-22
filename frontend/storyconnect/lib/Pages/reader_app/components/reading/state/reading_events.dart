part of 'reading_bloc.dart';

abstract class ReadingEvent {
  ReadingEvent();
}

class SwitchChapterEvent extends ReadingEvent {
  final int chapterToSwitchFrom;
  final int chapterToSwitchTo;
  final bool storeCommand;

  SwitchChapterEvent({
    required this.chapterToSwitchFrom,
    required this.chapterToSwitchTo,
    this.storeCommand = true,
  });
}

class DecrementChapterEvent extends SwitchChapterEvent {
  final int currentChapter;

  DecrementChapterEvent({required this.currentChapter})
      : super(
            chapterToSwitchFrom: currentChapter,
            chapterToSwitchTo: currentChapter - 1,
            storeCommand: false);
}

class IncrementChapterEvent extends SwitchChapterEvent {
  final int currentChapter;

  IncrementChapterEvent({required this.currentChapter})
      : super(
            chapterToSwitchFrom: currentChapter,
            chapterToSwitchTo: currentChapter + 1,
            storeCommand: false);
}

class LoadReadingEvent extends ReadingEvent {
  final FeedbackBloc feedbackBloc;

  LoadReadingEvent(this.feedbackBloc);
}

class SetEditorControllerCallbackEvent extends ReadingEvent {
  final EditorController? Function() callback;
  SetEditorControllerCallbackEvent({required this.callback});
}
