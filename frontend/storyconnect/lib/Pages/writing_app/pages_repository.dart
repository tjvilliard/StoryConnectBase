import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Services/url_service.dart';

class PagesApiProvider {
  final UrlBuilder _urlBuilder = UrlBuilder();

  Future<List<Chapter>> getChapters(int bookId) async {
    String authToken =
        await FirebaseAuth.instance.currentUser!.getIdToken(true) as String;

    final url = _urlBuilder.build(Uri.parse('books/$bookId/get_chapters'));
    final result = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $authToken'
    });

    final undecodedChapterList =
        jsonDecode(utf8.decode(result.bodyBytes)) as List;
    List<Chapter> results = [];
    for (var undecodedChapter in undecodedChapterList) {
      results.add(Chapter.fromJson(undecodedChapter));
    }
    return results;
  }

  Future<Chapter?> createChapter(int bookId, int number) async {
    try {
      String authToken =
          await FirebaseAuth.instance.currentUser!.getIdToken(true) as String;

      final ChapterUpload toUpload = ChapterUpload(
          number: number,
          chapterContent: "",
          book: bookId,
          chapterTitle: "$number");
      final url = _urlBuilder.build(Uri.parse('chapters/'));

      final result = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $authToken'
        },
        body: jsonEncode(toUpload.toJson()),
      );
      return Chapter.fromJson(jsonDecode(result.body));
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Chapter?> updateChapter(
      int bookId, int chapterId, int number, String text) async {
    try {
      String authToken =
          await FirebaseAuth.instance.currentUser!.getIdToken(true) as String;

      Chapter toUpload = Chapter(
          id: chapterId,
          number: number,
          chapterContent: text,
          book: bookId,
          chapterTitle: "$number");
      final url = _urlBuilder.build(Uri.parse('chapters/$chapterId/'));

      final result = await http.patch(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $authToken'
        },
        body: jsonEncode(toUpload.toJson()),
      );
      return Chapter.fromJson(jsonDecode(result.body));
    } catch (e) {
      print(e);
      return null;
    }
  }
}

class PagesProviderRepository {
  PagesApiProvider _api = PagesApiProvider();
  final int bookId;

  PagesProviderRepository({required this.bookId});

  Future<List<Chapter>> getChapters() async {
    return _api.getChapters(bookId);
  }

  Future<Chapter?> createChapter(int number) {
    return _api.createChapter(bookId, number);
  }

  Future<Chapter?> updateChapter(
      {required int chapterId, required int number, required String text}) {
    if (number == -1) {
      print("number is -1");
    }
    return _api.updateChapter(bookId, chapterId, number, text);
  }
}
