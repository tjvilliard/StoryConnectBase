import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/text_annotation/feedback.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/_state/writing_bloc.dart';
import 'package:storyconnect/Repositories/writing_repository.dart';

part 'feedback_event.dart';
part 'feedback_state.dart';
part 'feedback_bloc.freezed.dart';

typedef FeedbackEmitter = Emitter<FeedbackState>;

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  late final WritingRepository _repo;
  FeedbackBloc(WritingRepository repo) : super(FeedbackState.initial()) {
    _repo = repo;
    on<LoadChapterFeedback>((event, emit) => loadChapterFeedback(event, emit));
    on<FeedbackTypeChanged>((event, emit) => feedbackTypeChanged(event, emit));

    on<AcceptFeedbackEvent>((event, emit) => acceptFeedback(event, emit));
    on<RejectFeedbackEvent>((event, emit) => rejectFeedback(event, emit));
    on<DismissFeedbackEvent>((event, emit) => dismissFeedback(event, emit));

    on<ToggleGhostFeedbackEvent>((event, emit) => toggleGhostFeedback(event, emit));
  }

  void loadChapterFeedback(LoadChapterFeedback event, FeedbackEmitter emit) async {
    emit(state.copyWith(
      loadingStruct: LoadingStruct.message("Loading Feedback"),
    ));

    final currentFeedbacks = Map<int, List<WriterFeedback>>.from(state.feedbacks);

    final List<WriterFeedback> newFeedbacks = await _repo.getChapterFeedback(event.chapterId);

    // remove all the comments for the newly fetched chapter (if they exist) from the oldComments storage
    currentFeedbacks.remove(event.chapterId);

    // add the newly fetched comments to the oldComments storage
    currentFeedbacks[event.chapterId] = newFeedbacks;

    emit(state.copyWith(
      loadingStruct: LoadingStruct.loading(false),
      feedbacks: currentFeedbacks,
    ));
  }

  feedbackTypeChanged(FeedbackTypeChanged event, FeedbackEmitter emit) {
    emit(state.copyWith(
      selectedFeedbackType: event.feedbackType,
    ));
  }

  toggleGhostFeedback(ToggleGhostFeedbackEvent event, FeedbackEmitter emit) {
    emit(state.copyWith(
      showGhostFeedback: !state.showGhostFeedback,
    ));
  }

  // Modify the chapter, and delete the feedback from the list. Assert that it's a suggestion, and not a ghost feedback
  acceptFeedback(AcceptFeedbackEvent event, FeedbackEmitter emit) async {
    final feedback =
        state.feedbacks[event.writingBloc.currentChapterId]!.firstWhere((element) => element.id == event.feedbackId);

    assert(feedback.isSuggestion == true);
    assert(feedback.isGhost == false);

    String chapterText = event.writingBloc.state.currentChapterText;
    final chapterNum = event.writingBloc.state.currentIndex;

    chapterText =
        chapterText.replaceRange(feedback.selection.offset, feedback.selection.offsetEnd, feedback.suggestion!);

    final feedbacksState = Map<int, List<WriterFeedback>>.from(state.feedbacks);

    final feedbacks = feedbacksState[event.writingBloc.currentChapterId]!;

    final bool success = await _repo.acceptFeedback(
      feedback.id,
    );

    if (!success) {
      return;
    }

    feedbacks.remove(feedback);

    emit(state.copyWith(feedbacks: feedbacksState));

    event.writingBloc.add(UpdateChapterEvent(text: chapterText, chapterNum: chapterNum));
  }

  rejectFeedback(RejectFeedbackEvent event, FeedbackEmitter emit) async {
    final feedback = state.feedbacks[event.chapterId]!.firstWhere((element) => element.id == event.feedbackId);

    assert(feedback.isSuggestion == true);
    // Ghost feedbacks are fine to be rejected, since there's no modification of chapter text

    final feedbacksState = Map<int, List<WriterFeedback>>.from(state.feedbacks);

    final feedbacks = feedbacksState[event.chapterId]!;

    final bool success = await _repo.rejectFeedback(feedback.id);

    if (!success) {
      return;
    }

    feedbacks.remove(feedback);

    emit(state.copyWith(feedbacks: feedbacksState));
  }

  Future<void> dismissFeedback(DismissFeedbackEvent event, FeedbackEmitter emit) async {
    final feedback = state.feedbacks[event.chapterId]!.firstWhere((element) => element.id == event.feedbackId);

    assert(feedback.isSuggestion == false);
    assert(feedback.isGhost == false);

    final bool success = await _repo.dismissFeedback(feedback.id);

    if (!success) {
      return;
    }

    final feedbacksState = Map<int, List<WriterFeedback>>.from(state.feedbacks);
    final feedbacks = List<WriterFeedback>.from(feedbacksState[event.chapterId]!);

    feedbacks.removeWhere((element) => element.id == event.feedbackId);
    feedbacksState[event.chapterId] = feedbacks;

    emit(state.copyWith(feedbacks: feedbacksState));
  }
}
