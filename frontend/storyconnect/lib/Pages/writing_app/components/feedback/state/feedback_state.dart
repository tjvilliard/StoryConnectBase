part of 'feedback_bloc.dart';

enum FeedbackType { suggestion, comment }

@freezed
class FeedbackState with _$FeedbackState {
  const factory FeedbackState({
    required LoadingStruct loadingStruct,
    String? message,
    @Default({})
    Map<int, List<WriterFeedback>>
        feedbacks, // I too hate that the plural of feedback is feedback, so it is feedbacks here
    required FeedbackType selectedFeedbackType,
    required bool showGhostFeedback,
  }) = _FeedbackState;
  const FeedbackState._();

  List<WriterFeedback> get suggestions => feedbacks.values
      .expand((element) => element)
      .where((element) => element.isSuggestion)
      .toList();

  List<WriterFeedback> get comments => feedbacks.values
      .expand((element) => element)
      .where((element) => !element.isSuggestion)
      .toList();

  // initial state
  factory FeedbackState.initial() {
    return FeedbackState(
      showGhostFeedback: false,
      loadingStruct: LoadingStruct.loading(true),
      selectedFeedbackType: FeedbackType.suggestion,
    );
  }
}
