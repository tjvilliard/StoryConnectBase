part of 'reading_ui_bloc.dart';

@freezed
class ReadingUIState with _$ReadingUIState {
  const factory ReadingUIState({
    required int bookId,
    required bool chapterOutlineShown,
    required bool feedbackBarShown,
    required bool annotationBarShown,
    required ScrollController textScrollController,
    required EditorController editorController,
    String? title,
    required LoadingStruct loadingStruct,
  }) = _ReadingUIState;

  factory ReadingUIState.initial() {
    return ReadingUIState(
        bookId: 0,
        chapterOutlineShown: false,
        feedbackBarShown: false,
        annotationBarShown: false,
        textScrollController: ScrollController(),
        editorController: EditorController(),
        loadingStruct: LoadingStruct.loading(true));
  }
}
