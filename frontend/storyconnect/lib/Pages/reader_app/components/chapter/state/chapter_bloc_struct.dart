part of 'chapter_bloc.dart';

class ChapterBlocStruct {
  final int currentChapterIndex;
  final Map<int, String> chapters;
  final LoadingStruct loadingStruct;
  final int? caretOffset;
  Map<int, int> chapterNumToID = {};

  ChapterBlocStruct({
    required this.currentChapterIndex,
    required this.chapters,
    required this.loadingStruct,
    this.caretOffset,
  });

  String get currentChapterText => chapters[currentChapterIndex]!;
  int get currentChapterId => chapterNumToID[currentChapterIndex]!;

  ChapterBlocStruct copyWith({
    int? chapterIndex,
    Map<int, String>? chapters,
    LoadingStruct? loadingStruct,
    int? caretOffset,
    Map<int, int>? chapterNumToID,
  }) {
    final struct = ChapterBlocStruct(
      currentChapterIndex: chapterIndex ?? this.currentChapterIndex,
      chapters: chapters ?? this.chapters,
      loadingStruct: loadingStruct ?? this.loadingStruct,
      caretOffset: caretOffset ?? this.caretOffset,
    );

    struct.chapterNumToID = chapterNumToID ?? this.chapterNumToID;
    return struct;
  }

  factory ChapterBlocStruct.initial() {
    return ChapterBlocStruct(
        currentChapterIndex: 0,
        chapters: {0: ""},
        loadingStruct: LoadingStruct.loading(false));
  }
}
