import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/book_creation/serializers/book_creation_serializer.dart';
import 'package:storyconnect/Services/url_service.dart';

class WritingApiProvider {
  Future<Book?> createBook({required BookCreationSerializer serialzer}) async {
    try {
      String authToken =
          await FirebaseAuth.instance.currentUser!.getIdToken(true) as String;

      final url = UrlContants.books;
      final result = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $authToken'
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
      String authToken =
          await FirebaseAuth.instance.currentUser!.getIdToken(true) as String;

      final url = UrlContants.books;
      final result = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $authToken'
      });

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
  Future<int?> createBook({
    required BookCreationSerializer serializer,
  }) async {
    final output = await _api.createBook(serialzer: serializer);
    if (output != null) {
      books.add(output);
      return output.id;
    }
    return null;
  }

  Future<List<Book>> getBooks() async {
    final result = await _api.getBooks();
    // convert stream to future list and return
    return result.toList();
  }

  getChapterComments(int chapterId) {}
}
