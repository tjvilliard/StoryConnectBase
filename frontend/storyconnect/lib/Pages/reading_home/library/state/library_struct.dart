part of 'library_bloc.dart';

/// The Structure of the library home page.
class LibraryStruct {
  final Book? bookToNavigate;
  final List<Book> libraryBooks;

  LibraryStruct({
    this.bookToNavigate,
    required this.libraryBooks,
  });
}
