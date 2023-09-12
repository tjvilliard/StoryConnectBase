import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Repositories/writing_repository.dart';

part 'feedback_event.dart';
part 'feedback_state.dart';
part 'feedback_bloc.freezed.dart';

typedef FeedbackEmitter = Emitter<FeedbackState>;

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  late final WritingRepository _repo;
  FeedbackBloc(WritingRepository repo) : super(FeedbackState.initial()) {
    _repo = repo;
    on<LoadChapterComments>((event, emit) => loadChapterComments(event, emit));
    on<FeedbackTypeChanged>((event, emit) => feedbackTypeChanged(event, emit));
    on<ToggleGhostFeedbackEvent>(
        (event, emit) => toggleGhostFeedback(event, emit));
  }

  Stream<void> loadChapterComments(
      LoadChapterComments event, FeedbackEmitter emit) async* {
    emit(state.copyWith(
      loadingStruct: LoadingStruct.loading(true),
    ));

    final commentsState = state.comments;

    final List<Comment> comments =
        await _repo.getChapterComments(event.chapterId);

    // remove all the comments for the newly fetched chapter (if they exist) from the oldComments storage
    commentsState.remove(event.chapterId);

    // add the newly fetched comments to the oldComments storage
    commentsState[event.chapterId] = comments;

    emit(state.copyWith(
      loadingStruct: LoadingStruct.loading(false),
      comments: commentsState,
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
