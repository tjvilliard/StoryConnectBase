import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Services/url_service.dart';

class BookApiProvider {
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

  Future<Chapter?> createChapter(int bookId, int number) async {
    try {
      final ChapterUpload toUpload = ChapterUpload(
          number: number,
          chapterContent: "",
          book: bookId,
          chapterTitle: "$number");
      final url = UrlConstants.createChapter(bookId);

      final result = await http.post(
        url,
        headers: await buildHeaders(),
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
      final url = UrlConstants.updateChapter(chapterId);

      final result = await http.patch(
        url,
        headers: await buildHeaders(),
        body: jsonEncode(toUpload.toJson()),
      );
      return Chapter.fromJson(jsonDecode(result.body));
    } catch (e) {
      print(e);
      return null;
    }
  }
}

class BookProviderRepository {
  BookApiProvider _api = BookApiProvider();
  final int bookId;

  BookProviderRepository({required this.bookId});

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
