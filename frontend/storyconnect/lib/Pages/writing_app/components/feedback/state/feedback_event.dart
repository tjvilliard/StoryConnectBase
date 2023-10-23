part of 'feedback_bloc.dart';

abstract class FeedbackEvent {
  const FeedbackEvent();
}

class LoadChapterFeedback extends FeedbackEvent {
  final int chapterId;
  const LoadChapterFeedback(this.chapterId);
}

class FeedbackTypeChanged extends FeedbackEvent {
  final FeedbackType feedbackType;
  const FeedbackTypeChanged(this.feedbackType);
}

class ToggleGhostFeedbackEvent extends FeedbackEvent {
  const ToggleGhostFeedbackEvent();
}

class AcceptFeedbackEvent extends FeedbackEvent {
  final int feedbackId;
  final ChapterBloc chapterBloc;
  const AcceptFeedbackEvent({
    required this.feedbackId,
    required this.chapterBloc,
  });
}

class RejectFeedbackEvent extends FeedbackEvent {
  final int feedbackId;
  final int currentChapterId;
  RejectFeedbackEvent({
    required this.feedbackId,
    required this.currentChapterId,
  });
}

class DismissFeedbackEvent extends FeedbackEvent {
  final int feedbackId;
  const DismissFeedbackEvent({
    required this.feedbackId,
  });
}
