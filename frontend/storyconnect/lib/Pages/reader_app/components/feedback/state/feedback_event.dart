part of 'feedback_bloc.dart';

abstract class FeedbackEvent {
  const FeedbackEvent();
}

/// Load the comments for the chapter.
class LoadChapterComments extends FeedbackEvent {
  final int chapterId;
  const LoadChapterComments(this.chapterId);
}

class SuggestionEditedEvent extends FeedbackEvent {
  final String? suggestion;
  const SuggestionEditedEvent({required String? this.suggestion});
}

class CommentEditedEvent extends FeedbackEvent {
  final String? comment;
  const CommentEditedEvent({required String? this.comment});
}

class SentimentChangedEvent extends FeedbackEvent {
  final int sentiment;
  SentimentChangedEvent({required FeedbackSentiment sentiment})
      : this.sentiment = sentiment.index;
}

/// Change the type of feedback we are giving the writer.
class FeedbackTypeChanged extends FeedbackEvent {
  final FeedbackType feedbackType;
  const FeedbackTypeChanged(this.feedbackType);
}

/// Submits a new feedback item
class SubmitFeedbackEvent extends FeedbackEvent {
  final WriterFeedback feedbackItem;
  final ChapterBloc chapterBloc;
  const SubmitFeedbackEvent({
    required this.feedbackItem,
    required this.chapterBloc,
  });
}
