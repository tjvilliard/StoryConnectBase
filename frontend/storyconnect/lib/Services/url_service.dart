class _UrlBuilder {
  int version = 1; // use this later to change the api version
  String baseUrl = "http://storyconnect:8000/api/";

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

  static String book(int bookID) {
    return "/writer/book/$bookID";
  }

  static String writerProfile(int userID) {
    return "/profile/writer/$userID";
  }
}

class UrlContants {
  static final _urlBuilder = _UrlBuilder();

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
}
