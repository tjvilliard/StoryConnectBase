class PagesApiProvider {
  Future<Map<int, String>> fetchBook(int id) async {
    return {};
  }
}

class PagesRepository {
  PagesApiProvider _api = PagesApiProvider();
  Future<Map<int, String>> fetchChapters(int id) => _api.fetchBook(id);
}
