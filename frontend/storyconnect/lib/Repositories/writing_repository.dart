import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Models/text_annotation/feedback.dart';
import 'package:storyconnect/Pages/book_creation/serializers/book_creation_serializer.dart';
import 'package:storyconnect/Services/url_service.dart';

class WritingApiProvider {
  Future<String> getAuthToken() async {
    return (await FirebaseAuth.instance.currentUser!.getIdToken(true))
        as String;
  }

  Future<Book?> createBook({required BookCreationSerializer serialzer}) async {
    try {
      final url = UrlContants.books;
      final result = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token ${await getAuthToken()}'
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
      final url = UrlContants.writerBooks;
      final result = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token ${await getAuthToken()}'
        },
      );

      for (var book in jsonDecode(result.body)) {
        yield Book.fromJson(book);
      }
    } catch (e) {
      print(e);
    }
  }

  Stream<WriterFeedback> getFeedback(int chapterId) async* {
    final url = UrlContants.getWriterFeedback(chapterId);
    final result = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token ${await getAuthToken()}'
      },
    );
    for (var feedback in jsonDecode(result.body)) {
      yield WriterFeedback.fromJson(feedback);
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

  Future<List<WriterFeedback>> getChapterFeedback(int chapterId) async {
    List<WriterFeedback> feedback = [];

    await for (WriterFeedback item in _api.getFeedback(chapterId)) {
      feedback.add(item);
    }

    return feedback;
  }

  Future<bool> dismissFeedback(int id) async {
    return true;
  }

  Future<bool> rejectFeedback(int id) async {
    return true;
  }

  Future<bool> acceptFeedback(int id) async {
    return true;
  }

  getNarrativeElements(int bookId) {}
}
