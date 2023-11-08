part of 'feedback_bloc.dart';

/// Abstract class encapsulating the whole
/// set of feedback event items.
abstract class FeedbackEvent {
  const FeedbackEvent();
}

/// Load the comments for the chapter.
class LoadChapterFeedbackEvent extends FeedbackEvent {
  final int chapterId;
  const LoadChapterFeedbackEvent({
    required this.chapterId,
  });
}

/// Change the entry for the suggestion field.
class SuggestionEditedEvent extends FeedbackEvent {
  final String? suggestion;
  const SuggestionEditedEvent({
    required String? this.suggestion,
  });
}

/// Change the entry for the comment field.
class CommentEditedEvent extends FeedbackEvent {
  final String? comment;
  const CommentEditedEvent({
    required String? this.comment,
  });
}

/// Change the entry for the sentiment field.
class SentimentChangedEvent extends FeedbackEvent {
  final int sentiment;
  const SentimentChangedEvent({
    required this.sentiment,
  });
}

/// Change the type of feedback we are giving the writer.
class FeedbackTypeChangedEvent extends FeedbackEvent {
  final FeedbackType feedbackType;
  const FeedbackTypeChangedEvent({
    required this.feedbackType,
  });
}

/// Submits a new feedback item.
class SubmitFeedbackEvent extends FeedbackEvent {
  final int chapterId;
  const SubmitFeedbackEvent({
    required this.chapterId,
  });
}
