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

  /// The inital 'State' of FeedbackState:
  factory FeedbackState.initial() {
    return FeedbackState(
      loadingStruct: LoadingStruct.loading(true),
      serializer: FeedbackCreationSerializer.initial(),
      selectedFeedbackType: FeedbackType.suggestion,
    );
  }
}
