import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Constants/feedback_sentiment.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/text_annotation/feedback.dart';
import 'package:storyconnect/Models/text_annotation/text_selection.dart';
import 'package:storyconnect/Pages/reader_app/components/chapter/state/chapter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/serializers/feedback_serializer.dart';
import 'package:storyconnect/Repositories/reading_repository.dart';

part 'feedback_event.dart';
part 'feedback_state.dart';
part 'feedback_bloc.freezed.dart';

typedef FeedbackEmitter = Emitter<FeedbackState>;

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  ///
  late final ReadingRepository _repo;

  ///
  FeedbackBloc(ReadingRepository repo) : super(FeedbackState.initial()) {
    this._repo = repo;
    // load chapter comments
    // feedback type changed - make annotation, make comment, make suggestion

    // Map Incoming Events to methods.
    on<FeedbackTypeChangedEvent>(
        (event, emit) => feedbackTypeChanged(event, emit));
    on<SentimentChangedEvent>((event, emit) => sentimentChanged(event, emit));
    on<SuggestionEditedEvent>((event, emit) => suggestionEdited(event, emit));
    on<CommentEditedEvent>((event, emit) => commentEdited(event, emit));

    on<SubmitFeedbackEvent>((event, emit) => submitFeedback(event, emit));
    on<LoadChapterFeedbackEvent>(
        (event, emit) => loadChapterFeedback(event, emit));
  }

  /// Loads the feedback for the current Chapter.
  Stream<void> loadChapterFeedback(
      LoadChapterFeedbackEvent event, FeedbackEmitter emit) async* {
    emit(state.copyWith(
        loadingStruct: LoadingStruct.message("Loading Feedback")));

    // Get the current set of feedback items for the book.
    final currentFeedbackSet =
        Map<int, List<WriterFeedback>>.from(state.feedbackSet);

    // Update the set of feedback items for this current chapter.
    final List<WriterFeedback> newFeedbackSet =
        await this._repo.getChapterFeedback(event.chapterId);

    // Remove the old feedback item set
    currentFeedbackSet.remove(event.chapterId);

    // Replace it with the new one.
    currentFeedbackSet[event.chapterId] = newFeedbackSet;

    // Indicate that the operation is finished.
    emit(state.copyWith(
      loadingStruct: LoadingStruct.loading(false),
      feedbackSet: currentFeedbackSet,
    ));
  }

  /// Changes the type of sentiment and emits the changed state.
  sentimentChanged(SentimentChangedEvent event, FeedbackEmitter emit) {
    emit(state.copyWith(
        serializer: state.serializer.copyWith(sentiment: event.sentiment)));
  }

  /// Changes the type of feedback and emits the changed state.
  feedbackTypeChanged(FeedbackTypeChangedEvent event, FeedbackEmitter emit) {
    // We are changing state, and our new feedback type is a suggestion,
    // meaning the previous feedback type is a comment.
    if (event.feedbackType == FeedbackType.suggestion) {
      // Get the current state of the comment from our
      // current serializer state.
      String? commentState = state.serializer.comment;

      // Set the comment field to null and set
      // the suggestion field to the comment state.
      emit(state.copyWith(
          selectedFeedbackType: event.feedbackType,
          serializer: state.serializer.copyWith(
            isSuggestion: true,
            suggestion: commentState,
            comment: null,
          )));
    }
    // The new feedback type is a comment.
    else {
      // Get the current state of the suggestion field.
      String? suggestionState = state.serializer.suggestion;

      // Set fields in new serializer state accordingly.
      emit(state.copyWith(
          selectedFeedbackType: event.feedbackType,
          serializer: state.serializer.copyWith(
            isSuggestion: false,
            suggestion: null,
            comment: suggestionState,
          )));
    }
  }

  /// Changes the contents of the feedback suggestion and emits the changed state.
  suggestionEdited(SuggestionEditedEvent event, FeedbackEmitter emit) {
    emit(state.copyWith(
        serializer: state.serializer.copyWith(suggestion: event.suggestion)));
  }

  /// Changes the contents of the feedback comment and emits the changed comment.
  commentEdited(CommentEditedEvent event, FeedbackEmitter emit) {
    emit(state.copyWith(
        serializer: state.serializer.copyWith(comment: event.comment)));
  }

  /// Submits the feedback item, and emits the changed state.
  submitFeedback(SubmitFeedbackEvent event, FeedbackEmitter emit) {
    emit(state.copyWith(
        serializer: state.serializer.copyWith(
            selection: AnnotatedTextSelection(
              chapterId: event.chapterBloc
                  .chapterNumToID[event.chapterBloc.state.chapterIndex]!,
              floating: false,
              offset: 0,
              offsetEnd: 0,
              text: "",
            ),
            chapterId: event.chapterBloc
                .chapterNumToID[event.chapterBloc.state.chapterIndex]!)));

    print("Submitting Feedback");
    //this._repo.createChapterFeedback(serializer: state.serializer);
  }
}
