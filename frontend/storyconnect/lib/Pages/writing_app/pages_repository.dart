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

    final undecodedChapterList = jsonDecode(result.body) as List;
    List<Chapter> results = [];
    for (var undecodedChapter in undecodedChapterList) {
      results.add(Chapter.fromJson(undecodedChapter));
    }
    return results;
  }

  Future<bool> createChapter(int bookId, int number) async {
    try {
      final ChapterUpload toUpload =
          ChapterUpload(number: number, chapterContent: "", book: bookId);

      final result = await http.post(
        Uri.parse('https://storyconnect.app/api/chapters/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(toUpload.toJson()),
      );
      return result.statusCode == 201;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateChapter(int bookId, int number, String text) async {
    final result = await http.put(
      Uri.parse('https://storyconnect.app/api/books/$bookId/chapter/$number'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'text': text,
      }),
    );
    return result.statusCode == 200;
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

  Future<bool> createChapter(int number) {
    return _api.createChapter(bookId, number);
  }

  Future<bool> updateChapter(int number, String text) {
    return Future.delayed(Duration(seconds: 2), () {
      return true;
    });
  }
}
