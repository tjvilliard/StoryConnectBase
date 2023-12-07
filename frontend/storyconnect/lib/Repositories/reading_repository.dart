import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:storyconnect/Constants/copyright_constants.dart';
import 'package:storyconnect/Constants/language_constants.dart';
import 'package:storyconnect/Constants/search_constants.dart';
import 'package:storyconnect/Constants/target_audience_constants.dart';
import 'package:storyconnect/Models/genre_tagging/genre.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Models/text_annotation/feedback.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/serializers/feedback_serializer.dart';
import 'package:storyconnect/Pages/reading_hub/components/serializers/library_entry_serializer.dart';
import 'package:storyconnect/Services/url_service.dart';

/// API Endpoint for reading related tasks.
class ReadingApiProvider {
  /// Prints an exception for this file
  static void printException(String methodName, Object e) {
    // ignore: avoid_print
    print("[ERROR] [$methodName]: $e");
  }

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
        printException("createFeedbackItem", e);
      }
      return null;
    }
  }

  /// Endpoint for getting feedback items for a specific chapter.
  Stream<WriterFeedback> getChapterFeedback(int chapterId) async* {
    try {
      final url = UrlConstants.getWriterFeedback(chapterId);
      final result = await http.get(url, headers: await buildHeaders());

      for (var feedback in jsonDecode(utf8.decode(result.bodyBytes))) {
        yield WriterFeedback.fromJson(feedback);
      }
    } catch (e) {
      if (kDebugMode) {
        printException("getChapterFeedback", e);
      }
    }
  }
  // Feedback Related Endpoints

  // Book Specific Endpoints.
  /// API Endpoint for getting a specific book.
  Future<Book?> getBook(int? bookId) async {
    try {
      final url = UrlConstants.books(bookId: bookId);

      final result = await http.get(url, headers: await buildHeaders());

      final bookJson = jsonDecode(utf8.decode(result.bodyBytes));

      return Book.fromJson(bookJson);
    } catch (e) {
      if (kDebugMode) {
        printException("getBook", e);
      }
      return null;
    }
  }

  Stream<Book> getBookByFilter(
    String? search,
    LanguageConstant? language,
    CopyrightOption? copyright,
    TargetAudience? audience,
    SearchModeConstant searchMode,
  ) async* {
    try {
      final url = UrlConstants.booksQuery(
          search, language, copyright, audience, searchMode);
      final result = await http.get(url, headers: await buildHeaders());

      for (var book in jsonDecode(utf8.decode(result.bodyBytes))) {
        yield Book.fromJson(book);
      }
    } catch (e) {
      if (kDebugMode) {
        printException("getBookByFilter", e);
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
        printException("getAllBooks", e);
      }
    }
  }
  // Book Specific Endpoints.

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
        printException("getBookTags", e);
      }
      return null;
    }
  }
  // Book Specific Endpoints.

  // User and Profile Endpoints
  /// Retrievs the UUID associated with a given displayName, for linking purposes.
  Future<String?> getUUIDbyUsername(String displayName) async {
    try {
      final url = UrlConstants.getProfileName(displayName);

      final result = await http.get(url, headers: await buildHeaders());

      var uuid = jsonDecode(utf8.decode(result.bodyBytes));

      return uuid;
    } catch (e) {
      if (kDebugMode) {
        printException("getUUIDbyUsername", e);
      }
      return null;
    }
  }
  // User and Profile Endpoints.

  // Library Related Endpoints.
  /// API Endpoint for getting the full set of library books.
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
            reader: decode.reader,
          ),
          decode.book,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("[ERROR] [getLibraryBooks]: $e");
      }
    }
  }

  /// API endpoint for adding a new entry to a user's library.
  Future<void> addBooktoLibrary(LibraryEntrySerializer serializer) async {
    try {
      final url = UrlConstants.libraryBooks();

      await http.post(url,
          headers: await buildHeaders(),
          body: (jsonEncode(serializer.toJson())));
    } catch (e) {
      if (kDebugMode) {
        printException("addBooktoLibrary", e);
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
        printException("removeBookFromLibrary", e);
      }
    }
  }

  /// API endpoint for changing the status of a library Book.
  Future<void> changeLibraryBookStatus(Library library) async {
    try {
      final url = UrlConstants.libraryBookEntry(library.id);

      await http.patch(
        url,
        headers: await buildHeaders(),
        body: jsonEncode(library.toJson()),
      );
    } catch (e) {
      if (kDebugMode) {
        printException("changeLibraryBookStatus", e);
      }
    }
  }
  // Library Related Endpoints.

  /// Gets the Chapters for a the book-reading UI.
  Stream<Chapter> getChapters(int bookId) async* {
    try {
      final result = await http.get(UrlConstants.getChapters(bookId),
          headers: await buildHeaders());

      final undecodedChapterList = jsonDecode(utf8.decode(result.bodyBytes));

      for (var undecodedChapter in undecodedChapterList) {
        yield Chapter.fromJson(undecodedChapter);
      }
    } catch (e) {
      if (kDebugMode) {
        printException("getChapters", e);
      }
    }
  }
}

class ReadingRepository {
  final ReadingApiProvider _api = ReadingApiProvider();

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
    final Stream<WriterFeedback> feedbackSet =
        _api.getChapterFeedback(chapterId);
    return feedbackSet.toList();
  }

  /// Get The Book Info for a certain book.
  Future<Book?> getBook(int? bookId) async {
    final Book? book = await _api.getBook(bookId);
    return book;
  }

  Future<List<Book>> getBookByFilter(
    String? search,
    LanguageConstant? language,
    CopyrightOption? copyright,
    TargetAudience? audience,
    SearchModeConstant searchMode,
  ) async {
    final List<Book> books = await _api
        .getBookByFilter(search, language, copyright, audience, searchMode)
        .toList();
    return books;
  }

  /// Retrieves a list of all books.
  Future<List<Book>> getBooks() async {
    final Stream<Book> result = _api.getAllBooks();
    return result.toList();
  }

  /// Retrieves book tags associated with a book.
  Future<GenreTags?> getBookTags(int bookId) async {
    return await _api.getBookTags(bookId);
  }

  /// Retrives a map of the signed in user's Library Entries and Library Books.
  Future<Map<Library, Book>> getLibraryBooks() async {
    Map<Library, Book> libraryBookMap = {};
    await for (MapEntry<Library, Book> entry in _api.getLibraryBooks()) {
      libraryBookMap.addEntries([entry]);
    }
    return libraryBookMap;
  }

  /// Removes an entry from the user's library.
  Future<void> removeLibraryBook(LibraryEntrySerializer serialzier) async {
    await _api.removeBookFromLibrary(serialzier);
  }

  /// Adds an entry to the user's library.
  Future<void> addLibraryBook(LibraryEntrySerializer serialzier) async {
    await _api.addBooktoLibrary(serialzier);
  }

  /// Changes the status of a Library Entry.
  Future<void> changeLibraryBookStatus(Library library) async {
    await _api.changeLibraryBookStatus(library);
  }
  // Library Endpoints

  /// Retrieves the UUID associated with a displayName.
  Future<String?> getUUIDbyDisplayName(String displayName) async {
    return await _api.getUUIDbyUsername(displayName);
  }

  Future<List<Chapter>> getChapters(int bookId) async {
    final Stream<Chapter> response = _api.getChapters(bookId);
    return response.toList();
  }
}
