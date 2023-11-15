import 'package:firebase_auth/firebase_auth.dart';

/// Builder for api uri's
class _UrlBuilder {
  int version = 1; // use this later to change the api version
  String baseUrl = "http://localhost:8000/api/";

  Uri build(String path, {Map<String, String>? queryParameters}) {
    Uri partialURI = Uri.parse(baseUrl).resolveUri(Uri.parse(path));
    // if we don't have a trailing slash, add one
    if (!partialURI.path.endsWith('/')) {
      partialURI = partialURI.replace(path: partialURI.path + '/');
    }
    if (queryParameters != null) {
      partialURI = partialURI.replace(queryParameters: queryParameters);
    }
    return partialURI;
  }
}

Future<Map<String, String>> buildHeaders() async {
  String authToken =
      await FirebaseAuth.instance.currentUser!.getIdToken(true) as String;
  return <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Token $authToken'
  };
}

/// URL constants and builders for app pages.
class PageUrls {
  static const String register = "/register";

  static const String writerHome = "/writer/home";
  static const String createBook = "/writer/create_book";

  /// URL for reader home
  static const String readerHome = "/reader/home";

  /// URL for reader library
  static const String readerLibrary = "/reader/library";

  /// Url for specific writing book.
  static String book(int bookID) {
    return "/writer/book/$bookID";
  }

  /// URL for a specific reading book.
  static String readBook(int bookID) {
    return "/reader/book/$bookID";
  }

  /// URL for a writer's profile.
  static String writerProfile(String uid) {
    return "/profile/writer/$uid";
  }
}

/// URL constants for REST api calls.
class UrlConstants {
  static final _urlBuilder = _UrlBuilder();

  ///
  static Uri getWriterFeedback(int chapterId) {
    return _urlBuilder
        .build('feedback/by_chapter/')
        .replace(queryParameters: {'chapter': chapterId.toString()});
  }

  /// URI for HTTP Put request for creating writer feedback.
  static Uri createWriterFeedback() {
    return _urlBuilder.build('feedback');
  }

  ///
  static Uri getChapters(int bookId) {
    return _urlBuilder.build('books/$bookId/get_chapters');
  }

  static Uri books({String? uid}) {
    if (uid != null) {
      return _urlBuilder
          .build('books/writer/', queryParameters: {'username': uid});
    }
    return _urlBuilder.build('books/');
  }

  static Uri currentUserBooks() {
    return _urlBuilder.build(
      'books/writer/',
    );
  }

  static Uri createBook() {
    return _urlBuilder.build('books/');
  }

  ///
  static Uri createChapter(int bookId) {
    return _urlBuilder.build('chapters');
  }

  ///
  static Uri updateChapter(int chapterId) {
    return _urlBuilder.build('chapters/$chapterId/');
  }

  static Uri roadUnblock() {
    return _urlBuilder.build('road_unblock/');
  }

  /// library/get_user/library/ for getting user library.
  static Uri getUserLibrary() {
    return _urlBuilder.build('library/get_user_library/');
  }

  /// library/ url for adding entries to library
  static Uri addLibraryBook() {
    return _urlBuilder.build('library/');
  }

  /// library/change_entry_status for removing library entry.
  static Uri removeLibraryBook(int entryId) {
    return _urlBuilder.build('library/$entryId/change_entry_status/');
  }

  static Uri continuities(int chapterId) {
    return _urlBuilder.build('continuities/$chapterId');
  }

  static Uri getNarrativeElements(int bookId) {
    return _urlBuilder.build('narrative_elements/$bookId');
  }

  static Uri getDisplayName(int uid) {
    return _urlBuilder.build('display_name/$uid');
  }

  static Uri getBooksByUser({String? uid}) {
    if (uid != null) {
      return _urlBuilder
          .build('books/writer/', queryParameters: {'username': uid});
    }
    return _urlBuilder.build('books/writer/');
  }

  static Uri profiles({String? uid}) {
    if (uid != null) {
      return _urlBuilder.build('profiles/$uid');
    }
    return _urlBuilder.build('profiles/');
  }

  static Uri announcements({String? uid}) {
    if (uid != null) {
      return _urlBuilder.build('announcements/by_writer/$uid');
    }
    return _urlBuilder.build('announcements/');
  }

  static Uri activities({String? uid}) {
    if (uid != null) {
      return _urlBuilder.build('activities/by_writer/$uid');
    }
    return _urlBuilder.build('activities/');
  }
}
