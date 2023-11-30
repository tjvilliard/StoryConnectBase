part of 'feedback_bloc.dart';

/// Abstract class encapsulating the whole
/// set of feedback event items.
abstract class FeedbackEvent {
  const FeedbackEvent();
}

/// Load the comments for the chapter.
class LoadChapterFeedbackEvent extends FeedbackEvent {
  final int chapterId;
  const LoadChapterFeedbackEvent({required this.chapterId});
}

/// Change the entry for the content field.
class FeedbackEditedEvent extends FeedbackEvent {
  final String? comment;
  const FeedbackEditedEvent({
    required this.comment,
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

/// Updates the Recorded Annotation Item.
class AnnotationChangedEvent extends FeedbackEvent {
  final ReadingBloc readingBloc;
  final int offset;
  final int offsetEnd;
  final String text;

  ///
  const AnnotationChangedEvent({
    required this.readingBloc,
    required this.offset,
    required this.offsetEnd,
    required this.text,
  });
}

/// Submits a new feedback item.
class SubmitFeedbackEvent extends FeedbackEvent {
  final ReadingBloc readingBloc;
  const SubmitFeedbackEvent({
    required this.readingBloc,
  });
}
