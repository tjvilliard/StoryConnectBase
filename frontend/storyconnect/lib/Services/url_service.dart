class UrlBuilder {
  int version = 1; // use this later to change the api version
  String baseUrl = "http://localhost:8000/api/";

  Uri build(Uri path) {
    return Uri.parse(baseUrl).resolveUri(path);
  }
}
