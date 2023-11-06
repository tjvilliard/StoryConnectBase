part of 'writing_bloc.dart';

abstract class WritingEvent extends ReplayEvent {
  WritingEvent();
}

class SwitchChapterEvent extends WritingEvent {
  final int chapterToSwitchFrom;
  final int chapterToSwitchTo;
  final bool storeCommand;

  SwitchChapterEvent({
    required this.chapterToSwitchFrom,
    required this.chapterToSwitchTo,
    this.storeCommand = true,
  });
}

class UpdateChapterEvent extends WritingEvent {
  final String text;
  final bool storeCommand;

  UpdateChapterEvent({
    required this.text,
    this.storeCommand = true,
  });
}

class FeedbackLoadEvent extends WritingEvent {
  final FeedbackBloc feedbackBloc;

  FeedbackLoadEvent(this.feedbackBloc);
}

class AddChapterEvent extends WritingEvent {
  AddChapterEvent();
}

class RemoveChapterEvent extends WritingEvent {
  final int chapterNum;

  RemoveChapterEvent({required this.chapterNum});
}

class WritingUndoCommandEvent extends WritingEvent {
  WritingUndoCommandEvent();
}

class WritingRedoCommandEvent extends WritingEvent {
  WritingRedoCommandEvent();
}

class _UpdateChapterHelperEvent extends WritingEvent {
  final UpdateChapterEvent event;

  _UpdateChapterHelperEvent({required this.event});
}
