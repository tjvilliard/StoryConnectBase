import 'package:firebase_auth/firebase_auth.dart';

/// Builder for api uri's
class _UrlBuilder {
  int version = 1; // use this later to change the api version
  String baseUrl = "http://localhost:8000/api/";

  Uri build(String path, {Map<String, String>? queryParameters}) {
    Uri partialURI = Uri.parse(baseUrl).resolveUri(Uri.parse(path));
    // if we don't have a trailing slash, add one
    if (!partialURI.path.endsWith('/')) {
      partialURI = partialURI.replace(path: '${partialURI.path}/');
    }
    if (queryParameters != null) {
      partialURI = partialURI.replace(queryParameters: queryParameters);
    }
    return partialURI;
  }
}

Future<Map<String, String>> buildHeaders({bool noAuth = false}) async {
  final Map<String, String> baseHeaders = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8'
  };
  if (noAuth == true) {
    return baseHeaders;
  }
  String authToken =
      await FirebaseAuth.instance.currentUser!.getIdToken(true) as String;
  final authorizedHeaders = Map<String, String>.from(baseHeaders);
  authorizedHeaders.addAll({'Authorization': 'Token $authToken'});
  return authorizedHeaders;
}

/// URL constants and builders for app pages.
class PageUrls {
  static String getLastPathSegment(String url) {
    return url.split('/').last;
  }

  static const String register = "/register";

  static const String writerBase = "/writer";
  static const String writerHome = "$writerBase/home";
  static const String createBook = "$writerBase/create_book";
  static String book(int bookID) {
    return "$writerBase/book/$bookID";
  }

  // Login Page Urls
  static const String about = "/about";
  static const String login = "/login";

  static const String readerHome = "/reader/home";

  static const String readerLibrary = "/reader/library";

  static String bookDetails(int bookId) {
    return "/reader/details/$bookId";
  }

  /// URL for a specific reading book.
  static String readBook(int bookID) {
    return "/reader/book/$bookID";
  }

  static String readBookByChapter(int bookId, int chapterIndex) {
    return "reader/book/$bookId/$chapterIndex";
  }

  /// URL for a writer's profile.
  static String writerProfile(String uid) {
    return "/profile/writer/$uid";
  }
}

/// URL constants for REST API Endpoints.
class UrlConstants {
  static final _urlBuilder = _UrlBuilder();

  static Uri getBookTags(int bookId) {
    return _urlBuilder.build('genretagging/$bookId/');
  }

  // Feedback Endpoints
  ///
  static Uri getWriterFeedback(int chapterId) {
    return _urlBuilder
        .build('feedback/by_chapter/')
        .replace(queryParameters: {'chapter': chapterId.toString()});
  }

  /// URI for HTTP POST request for creating writer feedback.
  static Uri createWriterFeedback() {
    return _urlBuilder.build('feedback/');
  }
  // Feedback Endpoints

  ///
  static Uri getChapters(int bookId) {
    return _urlBuilder.build('books/$bookId/get_chapters');
  }

  static Uri books({String? uid, int? bookId}) {
    if (uid != null) {
      return _urlBuilder
          .build('books/writer/', queryParameters: {'username': uid});
    }
    if (bookId != null) {
      return _urlBuilder.build('books/$bookId/');
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

  static Uri getAllBooks() {
    return _urlBuilder.build('books/');
  }

  ///
  static Uri chapters({int? chapterId}) {
    if (chapterId != null) {
      return _urlBuilder.build('chapters/$chapterId/');
    }
    return _urlBuilder.build('chapters/');
  }

  static Uri roadUnblock() {
    return _urlBuilder.build('road_unblock/');
  }

  // Library Endpoints
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
    return _urlBuilder.build('library/$entryId/delete_entry/');
  }
  // Library Endpoints

  static Uri continuities(int chapterId) {
    return _urlBuilder.build('continuities/$chapterId');
  }

  static Uri getNarrativeElements(int bookId) {
    return _urlBuilder.build('narrative_elements/$bookId');
  }

  static Uri getProfileName(String displayName) {
    return _urlBuilder.build('username/by_display_name/$displayName?/');
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

  static Uri updateProfileImage() {
    return _urlBuilder.build('profile/image_upload/');
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

  static Uri verifyDisplayNameUniqueness() {
    return _urlBuilder.build('display_name/verify_uniqueness/');
  }
}
