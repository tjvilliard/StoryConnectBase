part of 'book_details_bloc.dart';

@freezed
class BookDetailsState with _$BookDetailsState {
  const factory BookDetailsState({
    required Book? book,
    required GenreTags? bookTags,
    required LoadingStruct bookDetailsLoadingStruct,
    required LoadingStruct chapterLoadingStruct,
    required String uuid,
    required List<Chapter> chapters,
  }) = _BookDetailsState;
  const BookDetailsState._();

  factory BookDetailsState.initial() {
    return BookDetailsState(
      book: null,
      bookTags: null,
      bookDetailsLoadingStruct: LoadingStruct.loading(true),
      chapterLoadingStruct: LoadingStruct.loading(true),
      uuid: "",
      chapters: [],
    );
  }
}
