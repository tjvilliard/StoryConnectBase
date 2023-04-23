import 'dart:io';

import 'package:storyconnect/Models/models.dart';

class WritingHomeApiProvider {
  HttpClient client = HttpClient();
  Future<Book> createBook() async {
    return Book(
        id: 1,
        title: "New Book",
        author: "John Joe",
        owner: 1,
        language: "english",
        targetAudience: 1,
        dateCreated: DateTime.now(),
        dateModified: DateTime.now(),
        synopsis: "",
        copyright: 1,
        titlepage: "");
  }
}

class WritingHomeRepository {
  WritingHomeApiProvider _api = WritingHomeApiProvider();
  Future<Book> createBook() => _api.createBook();
}
