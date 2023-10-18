part of 'library_bloc.dart';

/// The Structure of the library home page.
class LibraryStruct {
  final LoadingStruct loadingStruct;
  final Book? bookToNavigate;
  final List<Book> libraryBooks;

  LibraryStruct({
    required this.loadingStruct,
    this.bookToNavigate,
    required this.libraryBooks,
  });
}
