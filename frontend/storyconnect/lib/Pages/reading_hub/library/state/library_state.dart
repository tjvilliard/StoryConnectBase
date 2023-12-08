part of 'library_bloc.dart';

@freezed
class LibraryState with _$LibraryState {
  const factory LibraryState({
    required Map<Library, Book> libraryBookMap,
    required LoadingStruct libraryLoadingStruct,
  }) = _LibraryState;
  const LibraryState._();

  /// Gets the list of library books a reader is currently reading.
  List<Book> get currentlyReading => Map<Library, Book>.fromEntries(
          libraryBookMap.entries.where((entry) => entry.key.status == 1))
      .values
      .toList();

  /// Gets the list of library books a reader has marked as complete.
  List<Book> get completed => Map<Library, Book>.fromEntries(
          libraryBookMap.entries.where((entry) => entry.key.status == 2))
      .values
      .toList();

  /// Gets the list of library books a reader has marked as unread.
  List<Book> get unread => Map<Library, Book>.fromEntries(
          libraryBookMap.entries.where((entry) => entry.key.status == 3))
      .values
      .toList();

  /// Gets a book with a specific id.
  Book getBook(int bookId) {
    return libraryBookMap.values.firstWhere((book) => book.id == bookId);
  }

  bool containsBook(int bookId) {
    return libraryBookMap.values
        .where((element) => element.id == bookId)
        .isNotEmpty;
  }

  /// Gets a library with a specific id.
  Library getLibrary(int bookId) {
    return libraryBookMap.entries
        .firstWhere((entry) => entry.value.id == bookId)
        .key;
  }

  /// Gets a library-book map entry with a specific book id.
  MapEntry<Library, Book> getLibraryEntry(int bookId) {
    return libraryBookMap.entries
        .firstWhere((entry) => entry.value.id == bookId);
  }

  factory LibraryState.initial() {
    return LibraryState(
      libraryBookMap: {},
      libraryLoadingStruct: LoadingStruct.loading(true),
    );
  }
}
