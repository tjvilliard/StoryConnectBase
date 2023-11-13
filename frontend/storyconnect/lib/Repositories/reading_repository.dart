import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Models/text_annotation/feedback.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/serializers/feedback_serializer.dart';
import 'package:storyconnect/Services/url_service.dart';

class ReadingApiProvider {
  /// Generates HTTP: POST request for new feedback item.
  Future<WriterFeedback?> createFeedbackItem(
      {required FeedbackCreationSerializer serializer}) async {
    try {
      final url = UrlContants.createWriterFeedback();
      print("[INFO]: Getting result from post call. \n");

      final result = await http.post(
        url,
        headers: await buildHeaders(),
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
    final url = UrlConstants.getWriterFeedback(chapterId);
    final result = await http.get(url, headers: await buildHeaders());
    for (var feedback in jsonDecode(result.body)) {
      yield WriterFeedback.fromJson(feedback);
    }
  }

  Stream<Book> getBooks() async* {
    try {
      final url = UrlConstants.books;

      final result = await http.get(url, headers: await buildHeaders());

      for (var book in jsonDecode(result.body)) {
        yield Book.fromJson(book);
      }
    } catch (e) {
      print(e);
    }
  }

  /// Gets the full set of user library entries, the book id, the reader, the book reading state, etc...
  Stream<Library> getLibrary() async* {
    try {
      // get url for user library api call.
      final url = UrlConstants.getUserLibrary();

      // get result for HTTP GET request
      final result = await http.get(url, headers: await buildHeaders());

      for (var libraryEntry in jsonDecode(result.body)) {
        yield Library.fromJson(libraryEntry);
      }
    } catch (e) {
      print(e);
    }
  }

  /// Completes API action of adding a book to user library.
  Future<void> addBooktoLibrary(LibraryEntrySerialzier serializer) async {
    try {
      // get url for adding entry to user library api call.
      final url = UrlConstants.addLibraryBook();

      // send off HTTP POST request
      await http.post(url,
          headers: await buildHeaders(),
          body: (jsonEncode(serializer.toJson())));
    } catch (e) {
      print(e);
    }
  }

  /// Completes API action of removing a book from user library.
  Future<void> removeBookfromLibrary(LibraryEntrySerialzier serializer) async {
    try {
      // get url for removing entry from user library api call.
      final url = UrlConstants.removeLibraryBook(serializer.id!);

      // send off HTTP DELETE request
      await http.delete(url, headers: await buildHeaders());
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
