import 'dart:async';
// import 'dart:convert';
// import 'package:storyconnect/Services/url_service.dart';
// import 'package:http/http.dart' as http;
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/writer_profile/models/writer_profile_models.dart';

class ProfileApiProvider {
  Stream<Book> getBooksByUser(String uid) async* {
    // try {
    //   final url = UrlConstants.getBooksByUser(uid);
    //   final result = await http.get(url, headers: await buildHeaders());

    //   for (var book in jsonDecode(result.body)) {
    //     yield Book.fromJson(book);
    //   }
    // } catch (e) {
    //   print(e);
    // }

    yield Book(
      id: 2,
      title: "Test Book 1",
      synopsis: "This is a test synopsis 1",
      modified: DateTime.now(),
      created: DateTime.now(),
    );

    yield Book(
      id: 2,
      title: "Test Book 2",
      synopsis: "This is a test synopsis 2",
      modified: DateTime.now(),
      created: DateTime.now(),
    );
  }

  Stream<Announcement> getAnnouncements(String uid) async* {
    // try {
    //   final url = UrlConstants.getAnnouncements(uid);
    //   final result = await http.get(url, headers: await buildHeaders());

    //   for (var announcement in jsonDecode(result.body)) {
    //     yield Announcement.fromJson(announcement);
    //   }
    // } catch (e) {
    //   print(e);
    //   throw e;
    // }

    yield Announcement(
      id: 1,
      title: "Test Announcement",
      content: "This is a test announcement",
      writerId: uid,
      createdAt: DateTime.now(),
    );

    yield Announcement(
      id: 2,
      title: "Test Announcement 2",
      content: "This is a test announcement 2",
      writerId: uid,
      createdAt: DateTime.now(),
    );
  }

  Future<Profile> getProfile(String uid) async {
    // try {
    //   final url = UrlConstants.getProfile(uid);
    //   final result = await http.get(url, headers: await buildHeaders());

    //   return Profile.fromJson(jsonDecode(result.body));
    // } catch (e) {
    //   print(e);
    //   throw e;
    // }
    return Profile(
      id: 1,
      name: "Test User",
      bio: "This is a test bio",
      avatar: "",
    );
  }

  Future<bool> makeAnnouncement(String title, String content) async {
    // try {
    //   final serializer = AnnouncementSerializer(title: title, content: content);
    //   final url = UrlConstants.makeAnnouncement();
    //   final result = await http.post(url,
    //       headers: await buildHeaders(), body: jsonEncode(serializer.toJson()));

    //   return result.statusCode == 200;
    // } catch (e) {
    //   print(e);
    //   throw e;
    // }
    return true;
  }

  Stream<Activity> getActivities(String uid) async* {
    //   try {
    //     final url = UrlConstants.getActivities(uid);
    //     final result = await http.get(url, headers: await buildHeaders());

    //     for (var activity in jsonDecode(result.body)) {
    //       yield Activity.fromJson(activity);
    //     }
    //   } catch (e) {
    //     print(e);
    //     throw e;
    //   }
    // }

    yield Activity(
      id: 1,
      subject: 'Jonny',
      object: 'Burning Book',
      preposition: 'of the',
      action: 'worked on chapter 1',
      time: DateTime.now(),
    );

    yield Activity(
      id: 2,
      subject: 'Jonny',
      object: 'Burning Book',
      preposition: 'of the',
      action: 'worked on chapter 2',
      time: DateTime.now(),
    );
  }
}

class ProfileRepository {
  ProfileApiProvider _api = ProfileApiProvider();

  Future<List<Book>> getBooksByUser(String uid) async {
    return _api.getBooksByUser(uid).toList();
  }

  Future<List<Announcement>> getAnnouncements(String uid) async {
    return _api.getAnnouncements(uid).toList();
  }

  Future<Profile> getProfile(String uid) async {
    return _api.getProfile(uid);
  }

  Future<bool> makeAnnouncement(String title, String message) async {
    return _api.makeAnnouncement(title, message);
  }

  Future<List<Activity>> getActivities(String uid) {
    return _api.getActivities(uid).toList();
  }
}
