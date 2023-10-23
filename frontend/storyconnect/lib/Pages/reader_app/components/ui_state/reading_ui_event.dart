part of 'reading_ui_bloc.dart';

abstract class ReadingUIEvent {
  ReadingUIEvent();
}

class ReadingLoadEvent extends ReadingUIEvent {
  final int bookId;
  final ChapterBloc chapterBloc;
  ReadingLoadEvent({required this.bookId, required this.chapterBloc});
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

class ToggleToolbarEvent extends ReadingUIEvent {
  ToggleToolbarEvent();
}

class SwitchChapterEvent extends ReadingUIEvent {
  final int chapterID;
  SwitchChapterEvent({required this.chapterID});
}
