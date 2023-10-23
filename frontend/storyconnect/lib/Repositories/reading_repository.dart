import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Models/text_annotation/feedback.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/serializers/feedback_serializer.dart';
import 'package:storyconnect/Pages/reading_hub/components/serializers/library_entry_serializer.dart';
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
      print("getting feedback url");
      final url = UrlContants.createFeedback();
      print("getting result from post call");

      final result = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token ${await getAuthToken()}'
        },
        body: jsonEncode(serializer.toJson()),
      );

      print(result.body);

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
        'Authorization': 'Token ${await getAuthToken()}'
      });

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
      final url = UrlContants.getUserLibrary();

      String token = await getAuthToken();

      // get result for HTTP GET request
      final result = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token ${token}'
      });

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
      final url = UrlContants.addLibraryBook();

      // send off HTTP POST request
      await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Token ${await getAuthToken()}'
          },
          body: (jsonEncode(serializer.toJson())));
    } catch (e) {
      print(e);
    }
  }

  /// Completes API action of removing a book from user library.
  Future<void> removeBookfromLibrary(LibraryEntrySerialzier serializer) async {
    try {
      print("Getting url for delete request");
      // get url for removing entry from user library api call.
      final url = UrlContants.removeLibraryBook();

      String requestBody = jsonEncode(serializer.toJson());
      print(requestBody);
      print("Sending Delete Request");
      // send off HTTP DELETE request
      final result = await http.delete(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Token ${await getAuthToken()}'
          },
          body: (requestBody));

      print(result.body);
    } catch (e) {
      print(e);
    }
  }
}

class ReadingRepository {
  List<Book> libraryBooks = [];
  Map<String, List<Book>> taggedBooks = {};
  List<Book> books = [];
  ReadingApiProvider _api = ReadingApiProvider();

  /// Creates a new feedback item for chapter.
  Future<int?> createChapterFeedback({
    required FeedbackCreationSerializer serializer,
  }) async {
    print("Repo Call for chapter ID");

    final WriterFeedback? output =
        await this._api.createFeedbackItem(serializer: serializer);

    print("Got Output");

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

  /// Provided with a list of library entries, gets a list of books based
  /// on those entries.
  Future<List<Book>> getLibraryBooks() async {
    final result = await this._api.getLibrary();
    List<Library> entries = await result.toList();

    List<Book> books = await this.getBooks();

    List<Book> libraryBooks = [];
    for (Library entry in entries) {
      libraryBooks.addAll(books.where((book) => book.id == entry.book));
    }

    return libraryBooks;
  }

  Future<List<Library>> getLibraryEntries() async {
    final result = await this._api.getLibrary();

    List<Library> entries = await result.toList();

    return entries;
  }

  Future<List<int>> getLibraryBookIds() async {
    final result = await this._api.getLibrary();
    List<Library> entries = await result.toList();

    List<int> bookIds = [];

    for (Library entry in entries) {
      bookIds.add(entry.book);
    }
    return bookIds;
  }

  Future<void> addLibraryBook(LibraryEntrySerialzier serialzier) async {
    await this._api.addBooktoLibrary(serialzier);
  }

  Future<void> removeLibraryBook(LibraryEntrySerialzier serialzier) async {
    await this._api.removeBookfromLibrary(serialzier);
  }
}
