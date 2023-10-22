part of 'reading_ui_bloc.dart';

@freezed
class ReadingUIState with _$ReadingUIState {
  const factory ReadingUIState({
    required List<int> libBookIds,
    required bool chapterOutlineShown,
    required bool feedbackBarShown,
    required bool annotationBarShown,
    required bool toolbarShown,
    required bool appbarShown,
    String? title,
    required LoadingStruct loadingStruct,
  }) = _ReadingUIState;

  factory ReadingUIState.initial() {
    return ReadingUIState(
        libBookIds: [],
        chapterOutlineShown: false,
        feedbackBarShown: false,
        annotationBarShown: false,
        toolbarShown: false,
        appbarShown: false,
        loadingStruct: LoadingStruct.loading(true));
  }
}
