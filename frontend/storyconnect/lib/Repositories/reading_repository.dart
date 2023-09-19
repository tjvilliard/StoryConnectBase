import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Services/url_service.dart';

class ReadingApiProvider {
  //TODO: add differing kinds of book requests
  // some to be added with a search function, some by category.
  // Category based searches should not be hardcoded, but should be dynamic.

  //TODO: replace this generic getBooks request with more
  // sophisticated and dynamic requests.
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

class ReadingRepository {
  List<Book> books = [];
  ReadingApiProvider _api = ReadingApiProvider();

  Future<List<Book>> getBooks() async {
    final result = await this._api.getBooks();

    return result.toList();
  }
}
