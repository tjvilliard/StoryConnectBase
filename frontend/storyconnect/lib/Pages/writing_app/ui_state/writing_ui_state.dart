part of 'writing_ui_bloc.dart';

@freezed
class WritingUIState with _$WritingUIState {
  const factory WritingUIState({
    required bool chapterOutlineShown,
    required bool feedbackUIshown,
    String? title,
    required LoadingStruct loadingStruct,
  }) = _WritingUIState;

  // initial state
  factory WritingUIState.initial() {
    return WritingUIState(
      chapterOutlineShown: false,
      feedbackUIshown: false,
      loadingStruct: LoadingStruct.loading(true),
    );
  }
}
