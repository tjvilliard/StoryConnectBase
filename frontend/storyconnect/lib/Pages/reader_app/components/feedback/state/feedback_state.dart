part of 'feedback_bloc.dart';

enum FeedbackType { suggestion, comment }

@freezed
class FeedbackState with _$FeedbackState {
  const factory FeedbackState({
    required LoadingStruct loadingStruct,
    required FeedbackCreationSerializer serializer,
    @Default({}) Map<int, List<WriterFeedback>> feedbackSet,
    required FeedbackType selectedFeedbackType,
  }) = _FeedbackState;
  const FeedbackState._();

  List<WriterFeedback> get suggestions => feedbackSet.values
      .expand((element) => element)
      .where((element) => element.isSuggestion)
      .toList();

  List<WriterFeedback> get comments => feedbackSet.values
      .expand((element) => element)
      .where((element) => !element.isSuggestion)
      .toList();

  /// The inital 'State' of FeedbackState:
  factory FeedbackState.initial() {
    return FeedbackState(
      loadingStruct: LoadingStruct.loading(true),
      serializer: FeedbackCreationSerializer.initial(),
      selectedFeedbackType: FeedbackType.suggestion,
    );
  }
}
