import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/text_annotation/feedback.dart';
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
    on<ToggleGhostFeedbackEvent>(
        (event, emit) => toggleGhostFeedback(event, emit));
  }

  void loadChapterFeedback(
      LoadChapterFeedback event, FeedbackEmitter emit) async {
    emit(state.copyWith(
      loadingStruct: LoadingStruct.loading(true),
    ));

    final currentFeedbacks =
        Map<int, List<WriterFeedback>>.from(state.feedbacks);

    final List<WriterFeedback> newFeedbacks =
        await _repo.getChapterFeedback(event.chapterId);

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
}
