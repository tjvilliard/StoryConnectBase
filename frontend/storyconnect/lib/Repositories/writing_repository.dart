import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Models/text_annotation/feedback.dart';
import 'package:storyconnect/Pages/book_creation/serializers/book_creation_serializer.dart';
import 'package:storyconnect/Pages/writing_app/components/continuity_checker/models/continuity_models.dart';
import 'package:storyconnect/Pages/writing_app/components/narrative_sheet/models/narrative_element_models.dart';
import 'package:storyconnect/Services/url_service.dart';

class WritingApiProvider {
  Future<ContinuityResponse> getContinuities(int chapterId) async {
    // final url = UrlContants.continuities();
    // String authToken =
    //     (await FirebaseAuth.instance.currentUser!.getIdToken(true)) as String;
    // final result = await http.get(url, headers: <String, String>{
    //   'Content-Type': 'application/json; charset=UTF-8',
    //   'Authorization': 'Token $authToken'
    // });
    // return ContinuityResponse.fromJson(jsonDecode(result.body));

    return ContinuityResponse(
      suggestions: [
        ContinuitySuggestion(
          content: 'This is a suggestion',
          chapterId: chapterId,
          uuid: '1234',
          suggestionType: 'suggestion',
        ),
        ContinuitySuggestion(
          content: 'This is a warning',
          uuid: '1234',
          suggestionType: 'warning',
          chapterId: chapterId,
        ),
        ContinuitySuggestion(
          content: 'This is an error',
          uuid: '1234',
          suggestionType: 'error',
          chapterId: chapterId,
        ),
      ],
    );
  }

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

  Stream<NarrativeElement> getNarrativeElements(int bookId) async* {
    // try {
    //   final url = UrlContants.getNarrativeElements(bookId);
    //   final result = await http.get(
    //     url,
    //     headers: <String, String>{
    //       'Content-Type': 'application/json; charset=UTF-8',
    //       'Authorization': 'Token ${await getAuthToken()}'
    //     },
    //   );

    //   for (var element in jsonDecode(result.body)) {
    //     yield NarrativeElement.fromJson(element);
    //   }
    // } catch (e) {
    //   print(e);
    // }

// Mock the data in a stream paradigm
    final NarrativeElementType characterType = NarrativeElementType(
      name: "Character",
      userId: 1,
    );

    final NarrativeElementType locationType = NarrativeElementType(
      name: "Location",
      userId: 1,
    );

    yield NarrativeElement(
      bookId: bookId,
      elementType: characterType,
      attributes: [
        NarrativeElementAttribute(
          attribute: "Brave",
          attributeType: NarrativeElementAttributeType(
            userId: 1,
            name: "Personality",
            applicableTo: characterType,
          ),
          elementId: 1,
          confidence: .90,
          generated: true,
        ),
        NarrativeElementAttribute(
          attribute: "Fool-hardy",
          attributeType: NarrativeElementAttributeType(
            userId: 1,
            name: "Personality",
            applicableTo: characterType,
          ),
          elementId: 2,
          confidence: .50,
          generated: true,
        ),
        NarrativeElementAttribute(
          attribute: "Blonde Hair",
          attributeType: NarrativeElementAttributeType(
            userId: 1,
            name: "Physical Appearance",
            applicableTo: characterType,
          ),
          elementId: 1,
          confidence: .85,
          generated: true,
        ),
      ],
      userId: 1,
      name: "Elena",
      description: "Elena is a brave warrior from the northern tribes.",
      imageUrl: "https://example.com/images/elena.jpg",
      chapterId: 1,
    );

    yield NarrativeElement(
      bookId: bookId,
      elementType: locationType,
      attributes: [
        NarrativeElementAttribute(
          attribute: "Mystical",
          attributeType: NarrativeElementAttributeType(
            userId: 1,
            name: "Feature",
            applicableTo: locationType,
          ),
          elementId: 2,
          confidence: .25,
          generated: true,
        ),
        NarrativeElementAttribute(
          attribute: "Dimly Lit",
          attributeType: NarrativeElementAttributeType(
            userId: 1,
            name: "Lighting",
            applicableTo: locationType,
          ),
          elementId: 2,
          confidence: .92,
          generated: true,
        ),
      ],
      userId: 1,
      name: "Whispering Woods",
      description:
          "A dense forest known for its ancient mysteries and dim lighting.",
      imageUrl: "https://example.com/images/whispering_woods.jpg",
      chapterId: 1,
    );
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

  Future<List<NarrativeElement>> getNarrativeElements(int bookId) async {
    List<NarrativeElement> elements = [];

    await for (NarrativeElement item in _api.getNarrativeElements(bookId)) {
      elements.add(item);
    }

    return elements;
  }

  Future<ContinuityResponse?> getContinuities(int chapterId) async {
    return _api.getContinuities(chapterId);
  }
}
