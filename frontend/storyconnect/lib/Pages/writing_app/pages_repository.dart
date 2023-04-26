import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:storyconnect/Models/models.dart';

class PagesApiProvider {
  Future<List<Chapter>> getChapters(int bookId) async {
    final result = await http.get(
        Uri.parse('https://storyconnect.app/api/books/$bookId/get_chapters'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
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
      final ChapterUpload toUpload = ChapterUpload(
          number: number,
          chapterContent: "",
          book: bookId,
          chapterTitle: "$number");

      final result = await http.post(
        Uri.parse('https://storyconnect.app/api/chapters/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
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
      Chapter toUpload = Chapter(
          id: chapterId,
          number: number,
          chapterContent: text,
          book: bookId,
          chapterTitle: "$number");

      final result = await http.patch(
        Uri.parse('https://storyconnect.app/api/chapters/$chapterId/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
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
  // ignore: unused_field
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
    return _api.updateChapter(bookId, chapterId, number, text);
  }
}
