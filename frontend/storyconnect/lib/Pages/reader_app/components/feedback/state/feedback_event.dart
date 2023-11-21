part of 'feedback_bloc.dart';

/// Abstract class encapsulating the whole
/// set of feedback event items.
abstract class FeedbackEvent {
  const FeedbackEvent();
}

/// Change the entry for the suggestion field.
class FeedbackEditedEvent extends FeedbackEvent {
  final String? suggestion;
  const FeedbackEditedEvent({
    required this.suggestion,
  });
}

/// Change the entry for the comment field.
class CommentEditedEvent extends FeedbackEvent {
  final String? comment;
  const CommentEditedEvent({
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
  final ChapterBloc chapterBloc;
  final int offset;
  final int offsetEnd;
  final String text;

  ///
  const AnnotationChangedEvent({
    required this.chapterBloc,
    required this.offset,
    required this.offsetEnd,
    required this.text,
  });
}

/// Load the comments for the chapter.
class LoadChapterFeedbackEvent extends FeedbackEvent {
  final ChapterBloc chapterBloc;
  const LoadChapterFeedbackEvent(
    chapterId, {
    required this.chapterBloc,
  });
}

/// Submits a new feedback item.
class SubmitFeedbackEvent extends FeedbackEvent {
  final ChapterBloc chapterBloc;
  const SubmitFeedbackEvent({
    required this.chapterBloc,
  });
}
