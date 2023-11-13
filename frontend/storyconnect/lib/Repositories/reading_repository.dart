import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Models/text_annotation/feedback.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/serializers/feedback_serializer.dart';
import 'package:storyconnect/Services/url_service.dart';

class ReadingApiProvider {
  Future<String> getAuthToken() async {
    return (await FirebaseAuth.instance.currentUser!.getIdToken(true))
        as String;
  }

  /// Generates HTTP: POST request for new feedback item.
  Future<WriterFeedback?> createFeedbackItem(
      {required FeedbackCreationSerializer serializer}) async {
    try {
      final url = UrlContants.createWriterFeedback();
      print("[INFO]: Getting result from post call. \n");

      final token = await getAuthToken();

      final result = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token ${token}'
        },
        body: jsonEncode(serializer.toJson()),
      );

      print("[DEBUG]: Json Result: \n ${result.body} \n");

      return WriterFeedback.fromJson(jsonDecode(result.body));
    } catch (e) {
      print(e);
      return null;
    }
  }

  /// Get feedback items associated with this chapter.
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

  Stream<Book> getBooks() async* {
    try {
      final url = UrlContants.books;

      final result = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token ${await getAuthToken()}',
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
  Map<String, List<Book>> taggedBooks = {};
  List<Book> books = [];
  ReadingApiProvider _api = ReadingApiProvider();

  /// Creates a new feedback item for chapter.
  Future<int?> createChapterFeedback({
    required FeedbackCreationSerializer serializer,
  }) async {
    final WriterFeedback? output =
        await this._api.createFeedbackItem(serializer: serializer);

    if (output == null) {
      return null;
    } else {
      return output.id;
    }
  }

  /// Get The Feedback for this chapter.
  Future<List<WriterFeedback>> getChapterFeedback(int chapterId) async {
    List<WriterFeedback> feedback = [];

    await for (WriterFeedback item in this._api.getFeedback(chapterId)) {
      feedback.add(item);
    }

    return feedback;
  }

  Future<List<Book>> getBooks() async {
    final Stream<Book> result = await this._api.getBooks();
    return result.toList();
  }
}
