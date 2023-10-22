import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Models/text_annotation/feedback.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/serializers/feedback_serializer.dart';
import 'package:storyconnect/Pages/reading_hub/components/serializers/library_entry_serializer.dart';
import 'package:storyconnect/Services/url_service.dart';

class ReadingApiProvider {
  //TODO: add differing kinds of book requests
  // some to be added with a search function, some by category.
  // Category based searches should not be hardcoded, but should be dynamic.

  //TODO: replace this generic getBooks request with more
  // sophisticated and dynamic requests.

  Future<String> getAuthToken() async {
    return (await FirebaseAuth.instance.currentUser!.getIdToken(true))
        as String;
  }

  /// Generates HTTP: POST request for
  /// creating a new feedback item and reports the results.
  Future<WriterFeedback?> createFeedbackItem(
      {required FeedbackCreationSerializer serializer}) async {
    try {
      final url = UrlContants.createFeedback();

      final result = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token ${await getAuthToken()}'
        },
        body: jsonEncode(serializer.toJson()),
      );
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

  Stream<Library> getLibrary() async* {
    try {
      final url = UrlContants.getUserLibrary();

      final result = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token ${await getAuthToken()}'
      });
      print("Getting Library Books");
      print(result.body);
      for (var libraryEntry in jsonDecode(result.body)) {
        print(libraryEntry);
        yield Library.fromJson(libraryEntry);
      }
    } catch (e) {
      print(e);
    }
  }

  /// Completes the action of adding a book to the library.
  Future<void> addBooktoLibrary(int bookId) async {
    try {
      final url = UrlContants.addLibraryBook();

      print(jsonEncode(LibraryEntrySerialzier.initial(bookId).toJson()));

      await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Token ${await getAuthToken()}'
          },
          body: (jsonEncode(LibraryEntrySerialzier.initial(bookId).toJson())));
    } catch (e) {
      print(e);
    }
  }

  Stream<void> removeBookfromLibrary(int bookId) async* {
    try {
      final url = UrlContants.removeLibraryBook();

      final result = await http.delete(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Token ${await getAuthToken()}'
          },
          body: (jsonEncode(LibraryEntrySerialzier.initial(bookId).toJson())));

      print(result);
    } catch (e) {
      print(e);
    }
  }

  Future<int> getNumChapters(int bookId) async {
    try {
      final url = UrlContants.getChapters(bookId);

      final result = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token ${await getAuthToken()}'
      });

      final undecodedChapterList =
          jsonDecode(utf8.decode(result.bodyBytes)) as List;

      return undecodedChapterList.length;
    } catch (e) {
      print(e);
      return 0;
    }
  }
}

class ReadingRepository {
  List<Book> libraryBooks = [];
  Map<String, List<Book>> taggedBooks = {};
  List<Book> books = [];
  ReadingApiProvider _api = ReadingApiProvider();

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

  /// Gets the number of chapters associated with a book.
  Future<int> getNumChapters(int bookId) async {
    final int result = await this._api.getNumChapters(bookId);
    return result;
  }

  /// Provided with a list of library entries, gets a list of books based
  /// on those entries.
  Future<List<Book>> getLibraryBooks() async {
    final result = await this._api.getLibrary();
    List<Library> entries = await result.toList();

    List<Book> books = await this.getBooks();

    print(books);

    List<Book> libraryBooks = [];
    for (Library entry in entries) {
      libraryBooks.addAll(books.where((book) => book.id == entry.book));
    }

    return libraryBooks;
  }

  Future<void> addLibraryBook(int bookId) async {
    await this._api.addBooktoLibrary(bookId);
  }

  Future<Map<String, List<Book>>> getTaggedBooks() async {
    final result = await this._api.getBooks();

    return {"Library": await result.toList()};
  }
}
