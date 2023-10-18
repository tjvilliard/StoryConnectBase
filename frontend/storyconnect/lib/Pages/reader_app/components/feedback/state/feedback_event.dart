part of 'feedback_bloc.dart';

abstract class FeedbackEvent {
  const FeedbackEvent();
}

/// Load the comments for the chapter.
class LoadChapterComments extends FeedbackEvent {
  final int chapterId;
  const LoadChapterComments(this.chapterId);
}

///
class FeedbackTypeChanged extends FeedbackEvent {
  final FeedbackType feedbackType;
  const FeedbackTypeChanged(this.feedbackType);
}

class SubmitFeedbackEvent extends FeedbackEvent {
  //submit feedback item.
}
