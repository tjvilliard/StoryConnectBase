part of "chapter_bloc.dart";

class ChapterBlocStruct {
  final int chapterIndex;
  final Map<int, String> chapters;
  final LoadingStruct loadingStruct;
  final int? caretOffset;

  ChapterBlocStruct({
    required this.chapterIndex,
    required this.chapters,
    required this.loadingStruct,
    this.caretOffset,
  });

  ChapterBlocStruct copyWith(
      {int? chapterIndex,
      Map<int, String>? chapters,
      LoadingStruct? loadingStruct,
      int? caretOffset}) {
    return ChapterBlocStruct(
      chapterIndex: chapterIndex ?? this.chapterIndex,
      chapters: chapters ?? this.chapters,
      loadingStruct: loadingStruct ?? this.loadingStruct,
      caretOffset: caretOffset ?? this.caretOffset,
    );
  }

  factory ChapterBlocStruct.initial() {
    return ChapterBlocStruct(
        chapterIndex: 0,
        chapters: {0: ""},
        loadingStruct: LoadingStruct.loading(false));
  }
}
