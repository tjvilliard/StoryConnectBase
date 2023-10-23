part of 'writing_ui_bloc.dart';

@freezed
class WritingUIState with _$WritingUIState {
  const factory WritingUIState({
    required int bookId,
    required bool chapterOutlineShown,
    required bool feedbackUIshown,
    required bool roadUnblockerShown,
    required bool continuityCheckerShown,
    required ScrollController textScrollController,
    String? title,
    List<Rect>? rectsToHighlight,
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
      textScrollController: ScrollController(),
      loadingStruct: LoadingStruct.loading(true),
    );
  }
}
