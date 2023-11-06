part of 'writing_bloc.dart';

@freezed
class WritingState with _$WritingState {
  const factory WritingState({
    required int currentIndex,
    required Map<int, String> chapters,
    required LoadingStruct loadingStruct,
    int? caretOffset,
    @Default(<int, int>{}) Map<int, int> chapterNumToID,
  }) = _WritingState;
  const WritingState._();

  String get currentChapterText => chapters[currentIndex]!;
  int get currentChapterId => chapterNumToID[currentIndex]!;

  factory WritingState.initial() => WritingState(
        currentIndex: 0,
        chapters: {0: ""},
        loadingStruct: LoadingStruct.loading(true),
      );
}
