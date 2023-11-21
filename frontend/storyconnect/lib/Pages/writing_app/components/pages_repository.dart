import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Services/url_service.dart';

class BookApiProvider {
  Future<List<Chapter>> getChapters(int bookId) async {
    final result = await http.get(UrlConstants.getChapters(bookId), headers: await buildHeaders());

    final undecodedChapterList = jsonDecode(utf8.decode(result.bodyBytes)) as List;
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
      );
      final url = UrlConstants.chapters();

      final result = await http.post(
        url,
        headers: await buildHeaders(),
        body: jsonEncode(toUpload.toJson()),
      );
      return Chapter.fromJson(jsonDecode(utf8.decode(result.bodyBytes)));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<Chapter?> updateChapter(
      int bookId, int chapterId, int number, String content, String rawContent, String? title) async {
    try {
      Chapter toUpload = Chapter(
          id: chapterId,
          number: number,
          chapterContent: content,
          rawContent: rawContent,
          book: bookId,
          chapterTitle: title ?? "$number");
      final url = UrlConstants.chapters(chapterId: chapterId);

      final result = await http.patch(
        url,
        headers: await buildHeaders(),
        body: jsonEncode(toUpload.toJson()),
      );
      return Chapter.fromJson(jsonDecode(utf8.decode(result.bodyBytes)));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<bool> updateChapterTitle(
      int bookId, int chapterId, int number, String content, String rawContent, String? title) async {
    try {
      Chapter toUpload = Chapter(
          id: chapterId,
          number: number,
          chapterContent: content,
          rawContent: rawContent,
          book: bookId,
          chapterTitle: title ?? "$number");
      final url = UrlConstants.chapters(chapterId: chapterId);

      final result = await http.patch(
        url,
        headers: await buildHeaders(),
        body: jsonEncode(toUpload.toJson()),
      );
      return result.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> deleteChapter(int chapterId) async {
    try {
      final url = UrlConstants.chapters(chapterId: chapterId);
      await http.delete(url, headers: await buildHeaders());
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return false;
  }
}

class BookProviderRepository {
  final BookApiProvider _api = BookApiProvider();
  final int bookId;

  BookProviderRepository({required this.bookId});

  Future<List<Chapter>> getChapters() async {
    return _api.getChapters(bookId);
  }

  Future<Chapter?> createChapter(int number) {
    return _api.createChapter(bookId, number);
  }

  Future<Chapter?> updateChapter(
      {required int chapterId,
      required int number,
      required String content,
      required String rawContent,
      String? title}) {
    if (number == -1) {
      if (kDebugMode) {
        print("number is -1");
      }
    }
    return _api.updateChapter(bookId, chapterId, number, content, rawContent, title);
  }

  Future<bool> updateChapterTitle(
      {required int chapterId,
      required int number,
      required String content,
      required String rawContent,
      String? title}) {
    return _api.updateChapterTitle(bookId, chapterId, number, content, rawContent, title);
  }

  Future<bool> deleteChapter(int chapterId) {
    return _api.deleteChapter(chapterId);
  }
}
