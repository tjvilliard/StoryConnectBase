part of 'reading_hub_bloc.dart';

class ReadingHubStruct {
  final List<Book> recommendedBooks;
  final Map<Library, Book> libraryBookMap;
  final Book? bookToNavigate;
  final LoadingStruct loadingStruct;

  ReadingHubStruct({
    required this.recommendedBooks,
    required this.libraryBookMap,
    required this.loadingStruct,
    this.bookToNavigate,
  });
}
