part of 'feedback_bloc.dart';

enum FeedbackType { suggestion, comment, annotation }

@freezed
class FeedbackState with _$FeedbackState {
  const factory FeedbackState({
    required LoadingStruct loadingStruct,
    String? message,
    @Default({}) Map<int, List<dynamic>> comments,
    required FeedbackType selectedFeedbackType,
  }) = _FeedbackState;
  const FeedbackState._();

  /// The inital 'State' of FeedbackState:
  factory FeedbackState.initial() {
    return FeedbackState(
      loadingStruct: LoadingStruct.loading(true),
      selectedFeedbackType: FeedbackType.comment,
    );
  }
}
