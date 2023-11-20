part of 'reading_bloc.dart';

const VERTICAL_SPACING_EMPTY = VerticalSpacing(top: 0, bottom: 0);
const VERTICAL_BASE_SPACING = VerticalSpacing(top: 6, bottom: 0);

@freezed
class ReadingState with _$ReadingState {
  const factory ReadingState({
    required int currentIndex,
    required Map<int, String> chapters,
    required LoadingStruct loadingStruct,
    int? caretOffest,
    @Default(<int, int>{}) Map<int, int> chapterNumToID,
    required EditorConfigM config,
  }) = _ReadingState;
  const ReadingState._();

  String get currentChapterText => chapters[currentIndex]!;
  int get currentChapterId => chapterNumToID[currentIndex]!;

  factory ReadingState.initial() {
    return ReadingState(
        currentIndex: 0,
        chapters: {0: ""},
        loadingStruct: LoadingStruct.loading(true),
        config: EditorConfigM(
            customStyles: EditorStylesM(
                paragraph: TextBlockStyleM(
                    TextStyle(color: Colors.black, fontSize: 16, height: 1.3),
                    VERTICAL_SPACING_EMPTY,
                    VERTICAL_SPACING_EMPTY,
                    VERTICAL_SPACING_EMPTY,
                    null))));
  }
}

class _ParsedChapterResult {
  final Map<int, String> chapters;
  final Map<int, int> chapterNumToID;
  _ParsedChapterResult({required this.chapters, required this.chapterNumToID});
}
