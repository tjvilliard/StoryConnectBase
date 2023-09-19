part of 'writing_ui_bloc.dart';

abstract class WritingUIEvent {
  WritingUIEvent();
}

class UpdateAllEvent extends WritingUIEvent {
  final WritingUIState status;
  UpdateAllEvent({required this.status});
}

class ToggleChapterOutlineEvent extends WritingUIEvent {
  ToggleChapterOutlineEvent();
}

class ToggleCommentsUIEvent extends WritingUIEvent {
  ToggleCommentsUIEvent();
}

class ToggleRoadUnblockerEvent extends WritingUIEvent {
  ToggleRoadUnblockerEvent();
}

class SwitchChapterEvent extends WritingUIEvent {
  final int chapterId;
  SwitchChapterEvent({required this.chapterId});
}
