part of 'writing_bloc.dart';

abstract class WritingEvent extends ReplayEvent {
  WritingEvent();
}

class SwitchChapterEvent extends WritingEvent {
  final int chapterToSwitchTo;
  final bool storeCommand;

  SwitchChapterEvent({
    required this.chapterToSwitchTo,
    this.storeCommand = true,
  });
}

class UpdateChapterEvent extends WritingEvent {
  final String text;
  final int chapterNum;
  final bool storeCommand;

  UpdateChapterEvent({
    required this.text,
    required this.chapterNum,
    this.storeCommand = true,
  });
}

class LoadWritingEvent extends WritingEvent {
  final FeedbackBloc feedbackBloc;

  LoadWritingEvent(this.feedbackBloc);
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

class SetEditorControllerCallbackEvent extends WritingEvent {
  final EditorController? Function() callback;
  SetEditorControllerCallbackEvent({required this.callback});
}

class UpdateChapterTitleEvent extends WritingEvent {
  final String title;
  final int chapterNum;

  UpdateChapterTitleEvent({
    required this.title,
    required this.chapterNum,
  });
}

class DeleteChapterEvent extends WritingEvent {
  final int chapterNum;

  DeleteChapterEvent({
    required this.chapterNum,
  });
}
