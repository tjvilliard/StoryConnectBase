part of 'writing_ui_bloc.dart';

abstract class WritingUIEvent {
  const WritingUIEvent();
}

class UpdateAllEvent extends WritingUIEvent {
  final WritingUIState status;
  UpdateAllEvent({required this.status});
}

class ToggleChapterOutlineEvent extends WritingUIEvent {
  ToggleChapterOutlineEvent();
}

class ToggleFeedbackUIEvent extends WritingUIEvent {
  ToggleFeedbackUIEvent();
}

class ToggleRoadUnblockerEvent extends WritingUIEvent {
  ToggleRoadUnblockerEvent();
}

class SwitchChapterEvent extends WritingUIEvent {
  final int chapterId;
  SwitchChapterEvent({required this.chapterId});
}

class ToggleContinuityCheckerEvent extends WritingUIEvent {
  ToggleContinuityCheckerEvent();
}

class HighlightEvent extends WritingUIEvent {
  final AnnotatedTextSelection selection;
  final String chapterText;
  final TextStyle textStyle;

  const HighlightEvent({
    required this.selection,
    required this.chapterText,
    required this.textStyle,
  });
}
