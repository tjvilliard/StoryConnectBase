part of 'reading_ui_bloc.dart';

abstract class ReadingUIEvent {
  ReadingUIEvent();
}

class ReadingLoadEvent extends ReadingUIEvent {
  final int bookId;
  final int chapterIndex;
  final FeedbackBloc feedbackBloc;
  final ReadingBloc readingBloc;
  ReadingLoadEvent(
      {required this.bookId,
      required this.chapterIndex,
      required this.readingBloc,
      required this.feedbackBloc});
}

class UpdateAllEvent extends ReadingUIEvent {
  final ReadingUIState state;
  UpdateAllEvent({required this.state});
}

class ToggleChapterOutlineEvent extends ReadingUIEvent {
  ToggleChapterOutlineEvent();
}

class ToggleFeedbackBarEvent extends ReadingUIEvent {
  ToggleFeedbackBarEvent();
}

class ToggleAnnotationBarEvent extends ReadingUIEvent {
  ToggleAnnotationBarEvent();
}

class SwitchChapterEvent extends ReadingUIEvent {
  final int chapterID;
  SwitchChapterEvent({required this.chapterID});
}
