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
  final Map<String, String> baseHeaders = <String, String>{'Content-Type': 'application/json; charset=UTF-8'};
  if (noAuth == true) {
    return baseHeaders;
  }
  String authToken = await FirebaseAuth.instance.currentUser!.getIdToken(true) as String;
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

  /// URL for reader home
  static const String readerHome = "/reader/home";

  /// URL for reader library
  static const String readerLibrary = "/reader/library";

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
    return _urlBuilder.build('feedback/by_chapter/').replace(queryParameters: {'chapter': chapterId.toString()});
  }

  /// URI for HTTP Put request for creating writer feedback.
  static Uri createWriterFeedback() {
    return _urlBuilder.build('feedback');
  }

  ///
  static Uri getChapters(int bookId) {
    return _urlBuilder.build('books/$bookId/get_chapters');
  }

  static Uri books({String? uid, int? bookId}) {
    if (uid != null) {
      return _urlBuilder.build('books/writer/', queryParameters: {'username': uid});
    }
    if (bookId != null) {
      return _urlBuilder.build('books/$bookId/');
    }
    return _urlBuilder.build('books/');
  }

  /// Creates a Uri for various operations on narrative elements.
  ///
  /// This method supports the following operations:
  /// - Retrieving all narrative elements associated with a specific book (`bookId`).
  /// - Retrieving a specific narrative element by its primary key (`narrativeElementId`).
  /// - Generating narrative elements for a specific book (`bookId`) when `generate` is true.
  ///
  /// The URL scheme:
  /// - To retrieve all narrative elements for a book: /api/narrative_elements/?book_id=<book_id>
  /// - Url to a specific narrative element: /api/narrative_elements/<pk>
  /// - To generate narrative elements for a book: GET /api/narrative_elements/generate/<book_id>
  ///
  ///
  /// Arguments:
  ///   [narrativeElementId] (int?): The primary key of the narrative element to retrieve.
  ///   [bookId] (int?): The ID of the book for retrieving or generating narrative elements.
  ///   [generate] (bool): A flag to indicate if narrative elements should be generated for the given book.
  ///                      Defaults to false. When true, `bookId` cannot be null.
  ///
  /// Returns:
  ///   Uri: A Uri for the requested narrative element(s) or for the narrative element generation endpoint.
  ///
  /// Throws:
  ///   AssertionError: If the method parameters do not meet the required conditions.
  static Uri narrativeElements({int? narrativeElementId, int? bookId, bool generate = false}) {
    assert(!generate || bookId != null, 'bookId cannot be null when generate is true');
    assert((narrativeElementId != null) != (bookId != null),
        'Either narrativeElementId or bookId must be provided, but not both');

    if (generate) {
      return _urlBuilder.build('/api/narrative_elements/generate/$bookId');
    } else if (narrativeElementId != null) {
      return _urlBuilder.build('/api/narrative_elements/$narrativeElementId');
    } else {
      // Using query parameters for retrieving all narrative elements of a single book
      return _urlBuilder.build('/api/narrative_elements', queryParameters: {'book_id': bookId.toString()});
    }
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

  static Uri getDisplayName(int uid) {
    return _urlBuilder.build('display_name/$uid');
  }

  static Uri getBooksByUser({String? uid}) {
    if (uid != null) {
      return _urlBuilder.build('books/writer/', queryParameters: {'username': uid});
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
