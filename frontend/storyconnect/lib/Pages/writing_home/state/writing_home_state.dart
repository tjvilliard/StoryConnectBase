part of 'writing_home_bloc.dart';

@freezed
class WritingHomeState with _$WritingHomeState {
  factory WritingHomeState({
    required List<Book> books,
    required List<Book> searchingBooks,
    required LoadingStruct loadingStruct,
    required Book? bookToNavigate,
    required String? query,
  }) = _WritingHomeState;

  // initial state
  factory WritingHomeState.initial() {
    return WritingHomeState(
      books: [],
      searchingBooks: [],
      loadingStruct: LoadingStruct.loading(true),
      bookToNavigate: null,
      query: null,
    );
  }
}
