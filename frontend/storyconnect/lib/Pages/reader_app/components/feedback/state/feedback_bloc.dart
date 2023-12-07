import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/text_annotation/feedback.dart';
import 'package:storyconnect/Models/text_annotation/text_selection.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/serializers/feedback_serializer.dart';
import 'package:storyconnect/Pages/reader_app/components/reading/state/reading_bloc.dart';
import 'package:storyconnect/Repositories/reading_repository.dart';

part 'feedback_event.dart';
part 'feedback_state.dart';
part 'feedback_bloc.freezed.dart';

typedef FeedbackEmitter = Emitter<FeedbackState>;

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  late final ReadingRepository _repo;
  FeedbackBloc(ReadingRepository repo) : super(FeedbackState.initial()) {
    _repo = repo;

    on<FeedbackTypeChangedEvent>(
        (event, emit) => feedbackTypeChanged(event, emit));
    on<SentimentChangedEvent>((event, emit) => sentimentChanged(event, emit));
    on<FeedbackEditedEvent>((event, emit) => feedbackEdited(event, emit));

    on<SubmitFeedbackEvent>((event, emit) => submitFeedback(event, emit));
    on<AnnotationChangedEvent>((event, emit) => annotationChanged(event, emit));
    on<ClearAnnotationEvent>((event, emit) => clearAnnotation(event, emit));
    on<LoadChapterFeedbackEvent>(
        (event, emit) => loadChapterFeedback(event, emit));
  }

  void loadChapterFeedback(
      LoadChapterFeedbackEvent event, FeedbackEmitter emit) async {
    emit(state.copyWith(
      loadingStruct: LoadingStruct.message("Loading Feedback"),
    ));

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

  void clearAnnotation(ClearAnnotationEvent event, FeedbackEmitter emit) {
    emit(state.copyWith(
        serializer: state.serializer.copyWith(
            selection: const AnnotatedTextSelection(
                chapterId: 0,
                floating: false,
                offsetEnd: 0,
                offset: 0,
                text: ""))));
  }

  void feedbackTypeChanged(
      FeedbackTypeChangedEvent event, FeedbackEmitter emit) {
    emit(state.copyWith(
        selectedFeedbackType: event.feedbackType,
        serializer: state.serializer.copyWith(
          isSuggestion: !state.serializer.isSuggestion,
        )));
  }

  void feedbackEdited(FeedbackEditedEvent event, FeedbackEmitter emit) {
    emit(state.copyWith(
      serializer: state.serializer.copyWith(comment: event.comment),
    ));
  }

  void submitFeedback(SubmitFeedbackEvent event, FeedbackEmitter emit) async {
    int chapterId = event.readingBloc.state.currentChapterId;

    String loadingMessage =
        state.selectedFeedbackType == FeedbackType.suggestion
            ? "Posting Suggestion"
            : "Posting Comment";

    emit(state.copyWith(
      serializer: state.serializer.copyWith(
          selection: state.serializer.selection.copyWith(
        chapterId: chapterId,
      )),
      loadingStruct: LoadingStruct.message(loadingMessage),
    ));

    await _repo.createChapterFeedback(serializer: state.serializer);

    final currentFeedbackSet =
        Map<int, List<WriterFeedback>>.from(state.feedbackSet);

    final List<WriterFeedback> newFeedbackSet = await _repo
        .getChapterFeedback(event.readingBloc.state.currentChapterId);

    currentFeedbackSet.remove(event.readingBloc.state.currentChapterId);

    currentFeedbackSet[event.readingBloc.state.currentChapterId] =
        newFeedbackSet;

    emit(state.copyWith(
      feedbackSet: currentFeedbackSet,
      serializer: FeedbackCreationSerializer.initial().copyWith(
          isSuggestion: state.selectedFeedbackType == FeedbackType.suggestion),
      loadingStruct: LoadingStruct.loading(false),
    ));
  }
}
