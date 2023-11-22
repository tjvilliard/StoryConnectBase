part of 'reading_home_bloc.dart';

/// The Structure of the Reading Home.
/// The reading home manages a set of books mapped
/// to different genres of tags.
class ReadingHomeStruct {
  final List<Book> allBooks;
  final List<Book> libraryBooks;
  final Map<String, List<Book>> mappedBooks;
  final Book? bookToNavigate;
  final LoadingStruct loadingStruct;

  /// Creates a possible state of the reading home page.
  /// The state contains the following:
  /// -
  ReadingHomeStruct({
    required this.allBooks,
    required this.libraryBooks,
    required this.mappedBooks,
    required this.loadingStruct,
    this.bookToNavigate,
  });
}
