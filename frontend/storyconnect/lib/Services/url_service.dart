class UrlBuilder {
  int version = 1; // use this later to change the api version
  String baseUrl = "http://localhost:8000/api/";

  Uri build(Uri path) {
    return Uri.parse(baseUrl).resolveUri(path);
  }
}

class PageUrls {
  static const String writerHome = "/writer/home";
  static const String createBook = "/writer/create_book";
  static const String bookBaseUrl = "/writer/";
}

class UrlContants {}
