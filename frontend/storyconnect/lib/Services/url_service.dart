/// Builder for api uri's
class _UrlBuilder {
  int version = 1; // use this later to change the api version
  String baseUrl = "http://localhost:8000/api/";

  Uri build(String path) {
    final Uri partialURI = Uri.parse(baseUrl).resolveUri(Uri.parse(path));
    // if we don't have a trailing slash, add one
    if (!partialURI.path.endsWith('/')) {
      return partialURI.replace(path: partialURI.path + '/');
    } else {
      return partialURI;
    }
  }
}

/// URL constants and builders for app pages.
class PageUrls {
  static const String writerHome = "/writer/home";
  static const String createBook = "/writer/create_book";

  /// URL for reader home
  static const String readerHome = "/reader/home";

  /// URL for reader library
  static const String readerLibrary = "/reader/library";

  /// Url for specific writing book.
  static String book(int bookID) {
    return "/writer/book/$bookID";
  }

  /// URL for a specific reading book.
  static String readBook(int bookID) {
    return "/reader/book/$bookID";
  }

  /// URL for a writer's profile.
  static String writerProfile(int userID) {
    return "/profile/writer/$userID";
  }
}

/// URL constants for REST api calls.
class UrlContants {
  static final _urlBuilder = _UrlBuilder();

  ///
  static Uri getWriterFeedback(int chapterId) {
    return _urlBuilder
        .build('feedback/by_chapter/')
        .replace(queryParameters: {'chapter': chapterId.toString()});
  }

  ///
  static Uri getChapters(int bookId) {
    return _urlBuilder.build('books/$bookId/get_chapters');
  }

  ///
  static Uri createChapter(int bookId) {
    return _urlBuilder.build('chapters');
  }

  ///
  static Uri updateChapter(int chapterId) {
    return _urlBuilder.build('chapters/$chapterId/');
  }

  static Uri books = _urlBuilder.build('books/');
  static Uri writerBooks = books.resolve("by_writer/");

  static Uri roadUnblock() {
    return _urlBuilder.build('road_unblock/');
  }

  /// library/get_user/library/ for getting user library.
  static Uri getUserLibrary() {
    return _urlBuilder.build('library/get_user_library/');
  }

  /// library/ url for adding entries to library
  static Uri addLibraryBook() {
    return _urlBuilder.build('library/');
  }

  /// library/change_entry_status for removing library entry.
  static Uri removeLibraryBook(int entryId) {
    return _urlBuilder.build('library/$entryId/change_entry_status/');
  }

  static Uri createFeedback() {
    return _urlBuilder.build('feedback/');
  }

  static Uri continuities(int chapterId) {
    return _urlBuilder.build('continuities/$chapterId');
  }

  static getNarrativeElements(int bookId) {
    return _urlBuilder.build('narrative_elements/$bookId');
  }
}
