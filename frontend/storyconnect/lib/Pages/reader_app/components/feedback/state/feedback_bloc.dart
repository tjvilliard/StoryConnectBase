import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/text_annotation/feedback.dart';
import 'package:storyconnect/Models/text_annotation/text_selection.dart';
import 'package:storyconnect/Pages/reader_app/components/chapter/state/chapter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/serializers/feedback_serializer.dart';
import 'package:storyconnect/Repositories/reading_repository.dart';

part 'feedback_event.dart';
part 'feedback_state.dart';
part 'feedback_bloc.freezed.dart';

///
typedef FeedbackEmitter = Emitter<FeedbackState>;

///
class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  /// Feedback From Database
  late final ReadingRepository _repo;

  ///
  FeedbackBloc(ReadingRepository repo) : super(FeedbackState.initial()) {
    this._repo = repo;

    // Map incoming events to state transformations with methods.
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

    final currentFeedbackSet =
        Map<int, List<WriterFeedback>>.from(state.feedbackSet);

    print("Getting Chapter Bloc");

    ChapterBloc bloc = event.chapterBloc;

    print(bloc.currentChapterId);

    bloc.currentChapterId;

    // final List<WriterFeedback> newFeedbackSet =
    //    await this._repo.getChapterFeedback(event.chpaterBloc);

    // currentFeedbackSet.remove(event.chapterId);

    // currentFeedbackSet[event.chapterId] = newFeedbackSet;

    emit(state.copyWith(
      loadingStruct: LoadingStruct.loading(false),
      feedbackSet: currentFeedbackSet,
    ));
  }

  sentimentChanged(SentimentChangedEvent event, FeedbackEmitter emit) {
    emit(state.copyWith(
        serializer: state.serializer.copyWith(sentiment: event.sentiment)));

    print(event.sentiment);
    print(state.serializer.chapterId);
  }

  feedbackTypeChanged(FeedbackTypeChangedEvent event, FeedbackEmitter emit) {
    if (event.feedbackType == FeedbackType.suggestion) {
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
              chapterId: event.chapterBloc.currentChapterId,
              floating: false,
              offset: 0,
              offsetEnd: 0,
              text: "",
            ),
            chapterId: event.chapterBloc.currentChapterId)));

    print("Submitting Feedback");

    print("Feedback State: \n");

    print(state.serializer);

    //this._repo.createChapterFeedback(serializer: state.serializer);
  }
}
