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

class PageUrls {
  static const String writerHome = "/writer/home";
  static const String createBook = "/writer/create_book";
  static const String readerHome = "/reader/home";

  static String book(int bookID) {
    return "/writer/book/$bookID";
  }

  static String readBook(int bookID) {
    return "/reader/book/$bookID";
  }

  static String writerProfile(int userID) {
    return "/profile/writer/$userID";
  }
}

class UrlContants {
  static final _urlBuilder = _UrlBuilder();

  static Uri getWriterFeedback(int chapterId) {
    return _urlBuilder
        .build('feedback/by_chapter/')
        .replace(queryParameters: {'chapter': chapterId.toString()});
  }

  static Uri getChapters(int bookId) {
    return _urlBuilder.build('books/$bookId/get_chapters');
  }

  static Uri createChapter(int bookId) {
    return _urlBuilder.build('chapters');
  }

  static Uri updateChapter(int chapterId) {
    return _urlBuilder.build('chapters/$chapterId/');
  }

  static Uri books = _urlBuilder.build('books/');
  static Uri writerBooks = books.resolve("by_writer/");

  static Uri roadUnblock() {
    return _urlBuilder.build('road_unblock/');
  }

  static Uri continuities(int chapterId) {
    return _urlBuilder.build('continuities/$chapterId');
  }

  static getNarrativeElements(int bookId) {
    return _urlBuilder.build('narrative_elements/$bookId');
  }
}
