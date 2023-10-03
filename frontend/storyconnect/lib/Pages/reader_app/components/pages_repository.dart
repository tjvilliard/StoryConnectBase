import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Services/url_service.dart';

class BookApiProvider {
  Future<List<Chapter>> getChapters(int bookId) async {
    String authToken =
        await FirebaseAuth.instance.currentUser!.getIdToken(true) as String;

    final result = await http
        .get(UrlContants.getChapters(bookId), headers: <String, String>{
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
}

class BookProviderRepository {
  BookApiProvider _api = BookApiProvider();
  final int bookID;

  BookProviderRepository({required this.bookID});

  Future<List<Chapter>> getChapters() async {
    return _api.getChapters(this.bookID);
  }
}
