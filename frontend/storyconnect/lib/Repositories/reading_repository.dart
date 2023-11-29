import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Models/text_annotation/feedback.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/serializers/feedback_serializer.dart';
import 'package:storyconnect/Pages/reading_hub/components/serializers/library_entry_serializer.dart';
import 'package:storyconnect/Services/url_service.dart';

class ReadingApiProvider {
  /// Generates HTTP: POST request for new feedback item.
  Future<WriterFeedback?> createFeedbackItem(
      {required FeedbackCreationSerializer serializer}) async {
    try {
      final url = UrlConstants.createWriterFeedback();

      if (kDebugMode) {
        print("[DEBUG]: Sending Json String to Backend:");
        print("$serializer");
        print("");
      }

      if (kDebugMode) {
        print("[INFO]: Getting result from post call. \n");
      }

      final result = await http.post(
        url,
        headers: await buildHeaders(),
        body: jsonEncode(serializer.toJson()),
      );

      if (kDebugMode) {
        print("[DEBUG]: Json Result: \n ${result.body} \n");
      }

      return WriterFeedback.fromJson(jsonDecode(utf8.decode(result.bodyBytes)));
    } catch (e) {
      if (kDebugMode) {
        print("[Error]: $e");
      }
      return null;
    }
  }

  /// Get feedback items associated with this chapter.
  Stream<WriterFeedback> getFeedback(int chapterId) async* {
    if (kDebugMode) {
      print("Getting Chapter Feedback");
    }

    final url = UrlConstants.getWriterFeedback(chapterId);
    final result = await http.get(url, headers: await buildHeaders());
    for (var feedback in jsonDecode(utf8.decode(result.bodyBytes))) {
      yield WriterFeedback.fromJson(feedback);
    }
  }

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

  Stream<MapEntry<Library, Book>> getLibraryBooks() async* {
    try {
      final url = UrlConstants.getUserLibrary();

      final result = await http.get(url, headers: await buildHeaders());

      for (var map in jsonDecode(utf8.decode(result.bodyBytes))) {
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
}

class ReadingRepository {
  final ReadingApiProvider _api = ReadingApiProvider();
  Map<Library, Book> libraryBookMap = {};

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

    await for (WriterFeedback item in _api.getFeedback(chapterId)) {
      feedback.add(item);
    }

    return feedback;
  }

  /// Get
  Future<List<Book>> getBooks() async {
    final Stream<Book> result = _api.getAllBooks();
    return result.toList();
  }

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
}
