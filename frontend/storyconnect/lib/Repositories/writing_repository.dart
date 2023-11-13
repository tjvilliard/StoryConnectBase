import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:storyconnect/Constants/feedback_sentiment.dart';

import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Models/text_annotation/feedback.dart';
import 'package:storyconnect/Models/text_annotation/text_selection.dart';
import 'package:storyconnect/Pages/book_creation/serializers/book_creation_serializer.dart';
import 'package:storyconnect/Pages/writing_app/components/continuity_checker/models/continuity_models.dart';
import 'package:storyconnect/Pages/writing_app/components/narrative_sheet/models/narrative_element_models.dart';
import 'package:storyconnect/Services/url_service.dart';

class WritingApiProvider {
  Future<ContinuityResponse> getContinuities(int chapterId) async {
    final url = UrlConstants.continuities(chapterId);

    final result = await http.get(url, headers: await buildHeaders());
    return ContinuityResponse.fromJson(jsonDecode(result.body));
  }

  Future<Book?> createBook({required BookCreationSerializer serialzer}) async {
    try {
      final url = UrlConstants.books;
      final result = await http.post(
        url,
        headers: await buildHeaders(),
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
      final url = UrlConstants.writerBooks;
      final result = await http.get(url, headers: await buildHeaders());

      for (var book in jsonDecode(result.body)) {
        yield Book.fromJson(book);
      }
    } catch (e) {
      print(e);
    }
  }

  Stream<NarrativeElement> getNarrativeElements(int bookId) async* {
    try {
      final url = UrlConstants.getNarrativeElements(bookId);
      final result = await http.get(url, headers: await buildHeaders());

      for (var element in jsonDecode(result.body)) {
        yield NarrativeElement.fromJson(element);
      }
    } catch (e) {
      print(e);
    }
  }

  Stream<WriterFeedback> getFeedback(int chapterId) async* {
    final url = UrlConstants.getWriterFeedback(chapterId);
    final result = await http.get(url, headers: await buildHeaders());
    for (var feedback in jsonDecode(result.body)) {
      yield WriterFeedback.fromJson(feedback);
    }
    // test object
    yield WriterFeedback(
        id: 1,
        userId: 1,
        chapterId: chapterId,
        selection: AnnotatedTextSelection(
            floating: false,
            text: "This is a test",
            chapterId: 1,
            offset: 10,
            offsetEnd: 20),
        sentiment: FeedbackSentiment.values[1],
        isSuggestion: false,
        dismissed: false);
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
}
