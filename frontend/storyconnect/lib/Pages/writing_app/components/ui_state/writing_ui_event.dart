part of 'writing_ui_bloc.dart';

abstract class WritingUIEvent {
  const WritingUIEvent();
}

class UpdateAllEvent extends WritingUIEvent {
  final WritingUIState status;
  const UpdateAllEvent({required this.status});
}

class ToggleChapterOutlineEvent extends WritingUIEvent {
  const ToggleChapterOutlineEvent();
}

class ToggleFeedbackUIEvent extends WritingUIEvent {
  const ToggleFeedbackUIEvent();
}

class ToggleRoadUnblockerEvent extends WritingUIEvent {
  const ToggleRoadUnblockerEvent();
}

class SwitchChapterEvent extends WritingUIEvent {
  final int chapterId;
  const SwitchChapterEvent({required this.chapterId});
}

class ToggleContinuityCheckerEvent extends WritingUIEvent {
  const ToggleContinuityCheckerEvent();
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

class RemoveHighlightEvent extends WritingUIEvent {
  const RemoveHighlightEvent();
}

class WritingLoadEvent extends WritingUIEvent {
  final int bookId;
  final WritingBloc writingBloc;
  final FeedbackBloc feedbackBloc;
  const WritingLoadEvent({
    required this.bookId,
    required this.writingBloc,
    required this.feedbackBloc,
  });
}

class UpdateBookEvent extends WritingUIEvent {
  const UpdateBookEvent();
}

class DeleteBookEvent extends WritingUIEvent {
  const DeleteBookEvent();
}

class UpdateBookTitleEvent extends WritingUIEvent {
  final String title;
  const UpdateBookTitleEvent({required this.title});
}

class UpdateBookSynopsisEvent extends WritingUIEvent {
  final String synopsis;
  const UpdateBookSynopsisEvent({required this.synopsis});
}

class UpdateBookLanguageEvent extends WritingUIEvent {
  final String language;
  const UpdateBookLanguageEvent({required this.language});
}

class UpdateBookTargetAudienceEvent extends WritingUIEvent {
  final int targetAudience;
  const UpdateBookTargetAudienceEvent({required this.targetAudience});
}

class UpdateBookCopyrightEvent extends WritingUIEvent {
  final int copyright;
  const UpdateBookCopyrightEvent({required this.copyright});
}

class SelectUpdatedBookCoverEvent extends WritingUIEvent {
  SelectUpdatedBookCoverEvent();
}

class ClearUpdateBookEvent extends WritingUIEvent {
  ClearUpdateBookEvent();
}
