part of 'writing_ui_bloc.dart';

@freezed
class WritingUIState with _$WritingUIState {
  const factory WritingUIState({
    required int bookId,
    required bool chapterOutlineShown,
    required bool feedbackUIshown,
    required bool roadUnblockerShown,
    required bool continuityCheckerShown,
    String? title,
    required LoadingStruct loadingStruct,
  }) = _WritingUIState;

  // initial state
  factory WritingUIState.initial() {
    return WritingUIState(
      bookId: 0,
      chapterOutlineShown: false,
      feedbackUIshown: false,
      roadUnblockerShown: false,
      continuityCheckerShown: false,
      loadingStruct: LoadingStruct.loading(true),
    );
  }
}
