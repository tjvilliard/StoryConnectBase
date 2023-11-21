import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Services/url_service.dart';

/// Book Api Provider for the reading app.
/// Contains all the API calls related to getting books.
class BookApiProvider {
  /// Gets the Chapters for a the book-reading UI.
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
}

/// Repository for book chapters.
class BookProviderRepository {
  BookApiProvider _api = BookApiProvider();
  final int bookID;

  BookProviderRepository({required this.bookID});

  Future<List<Chapter>> getChapters() async {
    return _api.getChapters(this.bookID);
  }
}
