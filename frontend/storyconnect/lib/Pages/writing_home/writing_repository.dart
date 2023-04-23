import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:storyconnect/Models/models.dart';

class WritingHomeApiProvider {
  Future<Book> createBook({required String title}) async {
    final result = await http.post(
      Uri.parse('https://storyconnect.app/api/books'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
      }),
    );
    return Book.fromJson(jsonDecode(result.body));
  }

  Future<List<Book>> getBooks() async {
    final result = await http.get(
        Uri.parse('https://storyconnect.app/api/books'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });

    final undecodedBookList = jsonDecode(result.body) as List;
    return undecodedBookList.map((e) => Book.fromJson(e)).toList();
  }
}

class WritingHomeRepository {
  // ignore: unused_field
  WritingHomeApiProvider _api = WritingHomeApiProvider();
  Future<Book> createBook({
    required String title,
  }) {
    return Future.delayed(Duration(seconds: 2), () {
      return Book(
          id: 1,
          title: title,
          author: "author",
          owner: 1,
          language: "english",
          targetAudience: 1,
          dateCreated: DateTime.now(),
          dateModified: DateTime.now(),
          synopsis: "synopsis",
          copyright: 1,
          titlepage: "titlepage");
    });
  }

  Future<List<Book>> getBooks() async {
    return Future.delayed(Duration(seconds: 2), () {
      return <Book>[];
    });
  }

  Future<List<Chapter>> getChapters({required int bookId}) async {
    return Future.delayed(Duration(seconds: 2), () {
      return <Chapter>[];
    });
  }
}
