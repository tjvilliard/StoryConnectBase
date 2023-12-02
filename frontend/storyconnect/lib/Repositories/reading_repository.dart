import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:storyconnect/Models/genre_tagging/genre.dart';

import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Models/text_annotation/feedback.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/serializers/feedback_serializer.dart';
import 'package:storyconnect/Pages/reading_hub/components/serializers/library_entry_serializer.dart';
import 'package:storyconnect/Services/url_service.dart';

/// API Endpoint for reading related tasks.
class ReadingApiProvider {
  // Feedback Related Endpoints
  /// Endpoint for creating a new feedback Item for a specific chapter.
  Future<WriterFeedback?> createFeedbackItem(
      {required FeedbackCreationSerializer serializer}) async {
    try {
      final url = UrlConstants.createWriterFeedback();

      final result = await http.post(
        url,
        headers: await buildHeaders(),
        body: jsonEncode(serializer.toJson()),
      );

      return WriterFeedback.fromJson(jsonDecode(utf8.decode(result.bodyBytes)));
    } catch (e) {
      if (kDebugMode) {
        print("[ERROR]: $e");
      }
      return null;
    }
  }

  /// Endpoint for getting feedback items for a specific chapter.
  Stream<WriterFeedback> getChapterFeedback(int chapterId) async* {
    if (kDebugMode) {
      print("Getting Chapter Feedback");
    }

    final url = UrlConstants.getWriterFeedback(chapterId);
    final result = await http.get(url, headers: await buildHeaders());

    if (kDebugMode) {
      print("[INFO] Chapter Feedback Set");
    }
    for (var feedback in jsonDecode(utf8.decode(result.bodyBytes))) {
      if (kDebugMode) {
        print("");
        print(feedback);
      }
      yield WriterFeedback.fromJson(feedback);
    }
  }
  // Feedback Related Endpoints

  // Book Specific Endpoints.
  /// API Endpoint for getting a specific book.
  Future<Book?> getBook(int? bookId) async {
    try {
      final url = UrlConstants.books(bookId: bookId);

      if (kDebugMode) {
        print(url);
      }

      final result = await http.get(url, headers: await buildHeaders());

      if (kDebugMode) {
        print(result);
      }

      final bookJson = jsonDecode(utf8.decode(result.bodyBytes));

      return Book.fromJson(bookJson);
    } catch (e) {
      if (kDebugMode) {
        print("[ERROR] $e");
      }
      return null;
    }
  }

  /// Unused Endpoint.
  Stream<Book> getBooks() async* {
    try {
      final url = UrlConstants.books();

      final result = await http.get(url, headers: await buildHeaders());

      for (var book in jsonDecode(utf8.decode(result.bodyBytes))) {
        yield Book.fromJson(book);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  /// API Endpoint for getting a set of books.
  Stream<Book> getAllBooks() async* {
    try {
      final url = UrlConstants.getAllBooks();

      final result = await http.get(url, headers: await buildHeaders());

      for (var book in jsonDecode(utf8.decode(result.bodyBytes))) {
        yield Book.fromJson(book);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  /// API Endpoint for getting tags related to a book.
  Future<GenreTags?> getBookTags(int bookId) async {
    try {
      final url = UrlConstants.getBookTags(bookId);

      final result = await http.get(url, headers: await buildHeaders());

      // This is super duper hacky, but it can't be helped at the moment.
      var tagSet = jsonDecode(utf8.decode(result.bodyBytes)) as Iterable;

      if (tagSet.isEmpty) {
        return null;
      } else {
        var set = tagSet.first;

        return GenreTags.fromJson(set);
      }
    } catch (e) {
      if (kDebugMode) {
        print("[ERROR] $e");
      }
      return null;
    }
  }
  // Book Specific Endpoints.

  //
  ///
  Future<String?> getUUIDbyUsername(String displayName) async {
    try {
      final url = UrlConstants.getProfileName(displayName);

      final result = await http.get(url, headers: await buildHeaders());

      var uuid = jsonDecode(utf8.decode(result.bodyBytes));

      return uuid;
    } catch (e) {
      if (kDebugMode) {
        print("[ERROR] $e");
      }

      return null;
    }
  }
  //

  // Library Related Endpoints.
  /// API Endpoint for getting the full set of library books.
  Stream<MapEntry<Library, Book>> getLibraryBooks() async* {
    try {
      final url = UrlConstants.getUserLibrary();

      final result = await http.get(url, headers: await buildHeaders());

      for (var map in jsonDecode(utf8.decode(result.bodyBytes))) {
        print(map);

        LibraryBook decode = LibraryBook.fromJson(map);

        yield MapEntry<Library, Book>(
          Library(
            id: decode.id,
            status: decode.status,
          ),
          decode.book,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  /// API endpoint for adding a new entry to a user's library.
  Future<void> addBooktoLibrary(LibraryEntrySerializer serializer) async {
    try {
      final url = UrlConstants.addLibraryBook();

      // send off HTTP POST request
      await http.post(url,
          headers: await buildHeaders(),
          body: (jsonEncode(serializer.toJson())));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  /// API endpoint for removing an entry from a user's library.
  Future<void> removeBookFromLibrary(LibraryEntrySerializer serializer) async {
    try {
      final url = UrlConstants.removeLibraryBook(serializer.id!);

      await http.delete(
        url,
        headers: await buildHeaders(),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  /// API endpoint for changing the status of a library Book.
  Future<void> changeLibraryBookStatus(
      LibraryEntrySerializer serializer) async {
    try {} catch (e) {
      if (kDebugMode) {
        print("[ERROR] $e");
      }
    }
  }
  // Library Related Endpoints. //

  /// Gets the Chapters for a the book-reading UI.
  Future<List<Chapter>> getChapters(int bookId) async {
    final result = await http.get(UrlConstants.getChapters(bookId),
        headers: await buildHeaders());

    final undecodedChapterList =
        jsonDecode(utf8.decode(result.bodyBytes)) as List;
    List<Chapter> results = [];
    for (var undecodedChapter in undecodedChapterList) {
      results.add(Chapter.fromJson(undecodedChapter));
    }
    return results;
  }
}

class ReadingRepository {
  final ReadingApiProvider _api = ReadingApiProvider();
  Map<Library, Book> libraryBookMap = {};

  // Feedback Endpoints
  /// Creates a new feedback item for chapter.
  Future<int?> createChapterFeedback({
    required FeedbackCreationSerializer serializer,
  }) async {
    final WriterFeedback? output =
        await _api.createFeedbackItem(serializer: serializer);

    if (output == null) {
      return null;
    } else {
      return output.id;
    }
  }

  /// Get The Feedback for this chapter.
  Future<List<WriterFeedback>> getChapterFeedback(int chapterId) async {
    List<WriterFeedback> feedback = [];

    await for (WriterFeedback item in _api.getChapterFeedback(chapterId)) {
      feedback.add(item);
    }

    return feedback;
  }
  // Feedback Endpoints

  //
  /// Get The Book Info for a certain book.
  Future<List<Book>> getBooks() async {
    final Stream<Book> result = _api.getAllBooks();
    return result.toList();
  }

  ///
  Future<Book?> getBook(int? bookId) async {
    if (kDebugMode) {
      print("Getting Book : $bookId");
    }
    final Book? book = await _api.getBook(bookId);
    return book;
  }

  ///
  Future<GenreTags?> getBookTags(int bookId) async {
    if (kDebugMode) {
      print("Fetching Tags for Book : $bookId");
    }
    return await _api.getBookTags(bookId);
  }
  //

  // Library Endpoints
  ///
  Future<Map<Library, Book>> getLibraryBooks() async {
    Map<Library, Book> libraryBookMap = {};
    await for (MapEntry<Library, Book> entry in _api.getLibraryBooks()) {
      libraryBookMap.addEntries([entry]);
    }
    return libraryBookMap;
  }

  Future<void> removeLibraryBook(LibraryEntrySerializer serialzier) async {
    await _api.removeBookFromLibrary(serialzier);
  }

  Future<void> addLibraryBook(LibraryEntrySerializer serialzier) async {
    await _api.addBooktoLibrary(serialzier);
  }

  Future<void> changeLibraryBookStatus(
      LibraryEntrySerializer serializer) async {}
  // Library Endpoints

  ///
  Future<String?> getUUIDbyUsername(String displayName) async {
    return await _api.getUUIDbyUsername(displayName);
  }

  Future<List<Chapter>> getChapters(int bookID) async {
    return _api.getChapters(bookID);
  }
}
