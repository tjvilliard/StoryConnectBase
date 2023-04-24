import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:storyconnect/Models/models.dart';

class PagesApiProvider {
  Future<List<Chapter>> getChapters(int bookId) async {
    final result = await http.get(
        Uri.parse('https://storyconnect.app/api/books/$bookId/chapters'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });

    final undecodedChapterList = jsonDecode(result.body) as List;
    return undecodedChapterList.map((e) => Chapter.fromJson(e)).toList();
  }

  Future<bool> createChapter(int bookId, int number) async {
    final result = await http.post(
      Uri.parse('https://storyconnect.app/api/books/$bookId/chapter/$number'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return result.statusCode == 201;
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
    return Future.delayed(Duration(seconds: 2), () {
      return <Chapter>[];
    });
  }

  Future<bool> createChapter(int number) {
    return Future.delayed(Duration(seconds: 2), () {
      return true;
    });
  }

  Future<bool> updateChapter(int number, String text) {
    return Future.delayed(Duration(seconds: 2), () {
      return true;
    });
  }
}
