import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:storyconnect/Constants/feedback_sentiment.dart';

import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Models/text_annotation/feedback.dart';
import 'package:storyconnect/Models/text_annotation/text_selection.dart';
import 'package:storyconnect/Pages/writing_app/components/continuity_checker/models/continuity_models.dart';
import 'package:storyconnect/Pages/writing_app/components/narrative_sheet/models/narrative_element_models.dart';
import 'package:storyconnect/Services/url_service.dart';
import 'package:storyconnect/Widgets/book_forms/serializers/book_form_serializer.dart';

class WritingApiProvider {
  Future<ContinuityResponse> getContinuities(int chapterId) async {
    final url = UrlConstants.continuities(chapterId);

    final result = await http.get(url, headers: await buildHeaders());
    return ContinuityResponse.fromJson(jsonDecode(utf8.decode(result.bodyBytes)));
  }

  Future<Book?> createBook({required BookFormSerializer serialzer}) async {
    try {
      final url = UrlConstants.books();
      final result = await http.post(
        url,
        headers: await buildHeaders(),
        body: jsonEncode(serialzer.toJson()),
      );
      return Book.fromJson(jsonDecode(utf8.decode(result.bodyBytes)));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<Book?> updateBook({required BookFormSerializer serializer, required int bookId}) async {
    try {
      final url = UrlConstants.books(bookId: bookId);
      final result = await http.patch(
        url,
        headers: await buildHeaders(),
        body: jsonEncode(serializer.toJson()),
      );
      return Book.fromJson(jsonDecode(utf8.decode(result.bodyBytes)));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<void> deleteBook(int bookId) async {
    try {
      final url = UrlConstants.books(bookId: bookId);
      await http.delete(url, headers: await buildHeaders());
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Stream<Book> getBooks() async* {
    try {
      final url = UrlConstants.currentUserBooks();
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

  Stream<NarrativeElement> getNarrativeElements(int bookId) async* {
    try {
      final url = UrlConstants.narrativeElements(bookId: bookId);
      final result = await http.get(url, headers: await buildHeaders());

      for (var element in jsonDecode(utf8.decode(result.bodyBytes))) {
        yield NarrativeElement.fromJson(element);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Stream<WriterFeedback> getFeedback(int chapterId) async* {
    final url = UrlConstants.getWriterFeedback(chapterId);
    final result = await http.get(url, headers: await buildHeaders());
    for (var feedback in jsonDecode(utf8.decode(result.bodyBytes))) {
      yield WriterFeedback.fromJson(feedback);
    }
    // test object
    yield WriterFeedback(
        id: 1,
        userId: 1,
        chapterId: chapterId,
        selection: const AnnotatedTextSelection(
            floating: false, text: "This is a test", chapterId: 1, offset: 10, offsetEnd: 20),
        sentiment: FeedbackSentiment.values[1],
        isSuggestion: false,
        dismissed: false);
  }

  Stream<NarrativeElement> generateNarrativeElements(int bookID) async* {
    try {
      final url = UrlConstants.narrativeElements(bookId: bookID, generate: true);
      final result = await http.get(url, headers: await buildHeaders());

      for (var element in jsonDecode(utf8.decode(result.bodyBytes))) {
        yield NarrativeElement.fromJson(element);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}

class WritingRepository {
  List<Book> books = [];
  final WritingApiProvider _api = WritingApiProvider();
  Future<int?> createBook({
    required BookFormSerializer serializer,
  }) async {
    final output = await _api.createBook(serialzer: serializer);
    if (output != null) {
      books.add(output);
      return output.id;
    }
    return null;
  }

  Future<List<Book>> getBooks() async {
    final result = _api.getBooks();
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

  Future<List<NarrativeElement>> getNarrativeElements(int bookId) async {
    List<NarrativeElement> elements = [];

    await for (NarrativeElement item in _api.getNarrativeElements(bookId)) {
      elements.add(item);
    }

    return elements;
  }

  Future<ContinuityResponse?> getContinuities(int chapterId) async {
    final continuitiyResponse = await _api.getContinuities(chapterId);
    return continuitiyResponse;
  }

  Future<Book?> updateBook({required Book book, required int bookId}) async {
    // build serializer
    final serializer = BookFormSerializer(
        title: book.title,
        language: book.language,
        targetAudience: book.targetAudience,
        synopsis: book.synopsis,
        cover: book.cover,
        copyright: book.copyright);

    return _api.updateBook(serializer: serializer, bookId: bookId);
  }

  Future<void> deleteBook(int bookId) {
    return _api.deleteBook(bookId);
  }

  Future<List<NarrativeElement>> generateNarrativeSheet(int bookID) {
    return _api.generateNarrativeElements(bookID).toList();
  }
}
