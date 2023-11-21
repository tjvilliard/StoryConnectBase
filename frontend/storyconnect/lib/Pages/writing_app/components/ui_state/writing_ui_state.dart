part of 'writing_ui_bloc.dart';

@freezed
class BookEditorState with _$BookEditorState {
  const factory BookEditorState({
    required Book book,
    String? imageTitle,
    Uint8List? imageBytes,
  }) = _BookEditorState;

  // initial state
  factory BookEditorState.initial(Book book) {
    return BookEditorState(
      book: book,
    );
  }
}

@freezed
class WritingUIState with _$WritingUIState {
  const factory WritingUIState({
    required int bookId,
    required bool chapterOutlineShown,
    required bool feedbackUIshown,
    required bool roadUnblockerShown,
    required bool continuityCheckerShown,
    required ScrollController textScrollController,
    required EditorController editorController,
    Book? book,
    BookEditorState? bookEditorState,
    List<Rect>? rectsToHighlight,
    required LoadingStruct loadingStruct,
    @Default(false) bool isSaving,
  }) = _WritingUIState;

  // initial state
  factory WritingUIState.initial() {
    return WritingUIState(
        editorController: EditorController(),
        bookId: 0,
        chapterOutlineShown: false,
        feedbackUIshown: false,
        roadUnblockerShown: false,
        continuityCheckerShown: false,
        textScrollController: ScrollController(),
        loadingStruct: LoadingStruct.loading(true),
        isSaving: false);
  }
}
