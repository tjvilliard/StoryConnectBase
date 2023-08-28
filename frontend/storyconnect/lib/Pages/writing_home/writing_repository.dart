import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Services/url_service.dart';

class WritingHomeApiProvider {
  final UrlBuilder _urlBuilder = UrlBuilder();
  Future<Book?> createBook({required String title}) async {
    try {
      final url = _urlBuilder.build(Uri.parse('books/'));
      final result = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'title': title,
        }),
      );
      return Book.fromJson(jsonDecode(result.body));
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Book>> getBooks() async {
    try {
      final url = _urlBuilder.build(Uri.parse('books/'));
      final result = await http.get(
        url,
      );
      final undecodedBookList = jsonDecode(result.body) as List;
      List<Book> results = [];
      for (var book in undecodedBookList) {
        results.add(Book.fromJson(book));
      }
      return results;
    } catch (e) {
      print(e);
      return [];
    }
  }
}

class WritingRepository {
  List<Book> books = [];
  WritingHomeApiProvider _api = WritingHomeApiProvider();
  Future<Book?> createBook({
    required String title,
  }) {
    return _api.createBook(title: title);
  }

  Future<List<Book>> getBooks() async {
    final result = await _api.getBooks();
    books = result;
    return result;
  }
}
