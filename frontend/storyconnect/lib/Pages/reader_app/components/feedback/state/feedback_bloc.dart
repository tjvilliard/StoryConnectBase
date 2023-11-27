import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/text_annotation/feedback.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/serializers/feedback_serializer.dart';
import 'package:storyconnect/Pages/reader_app/components/reading/state/reading_bloc.dart';
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
    _repo = repo;

    // Map incoming events to state transformations with methods.
    on<FeedbackTypeChangedEvent>(
        (event, emit) => feedbackTypeChanged(event, emit));
    on<SentimentChangedEvent>((event, emit) => sentimentChanged(event, emit));
    on<FeedbackEditedEvent>((event, emit) => feedbackEdited(event, emit));

    on<SubmitFeedbackEvent>((event, emit) => submitFeedback(event, emit));
    on<AnnotationChangedEvent>((event, emit) => annotationChanged(event, emit));
    on<LoadChapterFeedbackEvent>(
        (event, emit) => loadChapterFeedback(event, emit));
  }

  /// Loads the feedback for the current Chapter.
  Stream<void> loadChapterFeedback(
      LoadChapterFeedbackEvent event, FeedbackEmitter emit) async* {
    if (kDebugMode) {
      print("Load Chapter Feebdack Event Detected");
    }

    emit(state.copyWith(
        loadingStruct: LoadingStruct.message("Loading Feedback")));

    final currentFeedbackSet =
        Map<int, List<WriterFeedback>>.from(state.feedbackSet);

    final List<WriterFeedback> newFeedbackSet =
        await _repo.getChapterFeedback(event.chapterId);

    currentFeedbackSet.remove(event.chapterId);

    currentFeedbackSet[event.chapterId] = newFeedbackSet;

    emit(state.copyWith(
      loadingStruct: LoadingStruct.loading(false),
      feedbackSet: currentFeedbackSet,
    ));
  }

  void sentimentChanged(SentimentChangedEvent event, FeedbackEmitter emit) {
    emit(state.copyWith(
        serializer: state.serializer.copyWith(sentiment: event.sentiment)));
  }

  void annotationChanged(AnnotationChangedEvent event, FeedbackEmitter emit) {
    emit(state.copyWith(
        serializer: state.serializer.copyWith(
            selection: state.serializer.selection.copyWith(
      offset: event.offset,
      offsetEnd: event.offsetEnd,
      chapterId: event.readingBloc.state.currentChapterId,
      text: event.text,
    ))));
  }

  void feedbackTypeChanged(
      FeedbackTypeChangedEvent event, FeedbackEmitter emit) {
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
  void feedbackEdited(FeedbackEditedEvent event, FeedbackEmitter emit) {
    if (state.selectedFeedbackType == FeedbackType.suggestion) {
      emit(state.copyWith(
        serializer: state.serializer.copyWith(suggestion: event.suggestion),
      ));
    } else {
      emit(state.copyWith(
        serializer: state.serializer.copyWith(comment: event.suggestion),
      ));
    }
  }

  /// Submits the feedback item, and emits the changed state.
  void submitFeedback(SubmitFeedbackEvent event, FeedbackEmitter emit) {
    int chapterId = event.readingBloc.state.currentChapterId;

    String loadingMessage =
        state.selectedFeedbackType == FeedbackType.suggestion
            ? "Posting Suggestion"
            : "Posting Comment";

    emit(state.copyWith(
      serializer: state.serializer.copyWith(
          chapterId: chapterId,
          selection: state.serializer.selection.copyWith(
            chapterId: chapterId,
          )),
      loadingStruct: LoadingStruct.message(loadingMessage),
    ));

    _repo.createChapterFeedback(serializer: state.serializer);
  }
}
