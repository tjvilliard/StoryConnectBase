part of 'reading_hub_bloc.dart';

///
class ReadingHubStruct {
  final List<Book> allBooks;
  final Map<Library, Book> libraryBookMap;
  final Map<String, List<Book>> mappedBooks;
  final Book? bookToNavigate;
  final LoadingStruct loadingStruct;

  /// Creates a possible state of the reading home page.
  /// The state contains the following:
  ///- Library Book Map
  ///-
  ReadingHubStruct({
    required this.allBooks,
    required this.libraryBookMap,
    required this.mappedBooks,
    required this.loadingStruct,
    this.bookToNavigate,
  });
}
