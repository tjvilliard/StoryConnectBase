import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/book_creation/serializers/book_creation_serializer.dart';
import 'package:storyconnect/Services/url_service.dart';

class WritingApiProvider {
  final UrlBuilder _urlBuilder = UrlBuilder();

  Future<Book?> createBook({required BookCreationSerializer serialzer}) async {
    try {
      final url = _urlBuilder.build(Uri.parse('books/'));
      final result = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(serialzer.toJson()),
      );
      return Book.fromJson(jsonDecode(result.body));
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<Book> getBooks() async* {
    try {
      final url = _urlBuilder.build(Uri.parse('books/'));
      final result = await http.get(
        url,
      );

      for (var book in jsonDecode(result.body)) {
        yield Book.fromJson(book);
      }
    } catch (e) {
      print(e);
    }
  }
}

class WritingRepository {
  List<Book> books = [];
  WritingApiProvider _api = WritingApiProvider();
  Future<bool> createBook({
    required BookCreationSerializer serializer,
  }) async {
    final output = await _api.createBook(serialzer: serializer);
    if (output != null) {
      books.add(output);
      return true;
    }
    return false;
  }

  Future<List<Book>> getBooks() async {
    final result = await _api.getBooks();
    // convert stream to future list and return
    return result.toList();
  }
}
