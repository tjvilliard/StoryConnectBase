part of 'feedback_bloc.dart';

enum FeedbackType { suggestion, comment }

@freezed
class FeedbackState with _$FeedbackState {
  const factory FeedbackState({
    required LoadingStruct loadingStruct,
    String? message,
    @Default({}) Map<int, List<Comment>> comments,
    required FeedbackType selectedFeedbackType,
    required bool showGhostFeedback,
  }) = _FeedbackState;
  const FeedbackState._();

  // initial state
  factory FeedbackState.initial() {
    return FeedbackState(
      showGhostFeedback: false,
      loadingStruct: LoadingStruct.loading(true),
      selectedFeedbackType: FeedbackType.suggestion,
    );
  }
}
