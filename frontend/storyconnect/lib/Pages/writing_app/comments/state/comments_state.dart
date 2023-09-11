part of 'comments_bloc.dart';

@freezed
class CommentsState with _$CommentsState {
  const factory CommentsState({
    required LoadingStruct loadingStruct,
    String? message,
    Map<int, List<Comment>>? comments,
  }) = _CommentsState;
  const CommentsState._();

  // initial state
  factory CommentsState.initial() {
    return CommentsState(
      loadingStruct: LoadingStruct.loading(true),
    );
  }
}
