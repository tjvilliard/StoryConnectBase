import 'dart:async';
import 'dart:convert';
import 'package:storyconnect/Services/url_service.dart';
import 'package:http/http.dart' as http;
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/writer_profile/models/writer_profile_models.dart';

class CoreApiProvider {
  Stream<Book> getBooksByUser(String uid) async* {
    try {
      final url = UrlConstants.getBooksByUser(uid: uid);
      final result = await http.get(url, headers: await buildHeaders());

      for (var book in jsonDecode(result.body)) {
        yield Book.fromJson(book);
      }
    } catch (e) {
      print(e);
    }
  }

  Stream<Announcement> getAnnouncements(String uid) async* {
    try {
      final url = UrlConstants.announcements(uid: uid);
      final result = await http.get(url, headers: await buildHeaders());

      for (var announcement in jsonDecode(result.body)) {
        yield Announcement.fromJson(announcement);
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<Profile> getProfile(String uid) async {
    try {
      final url = UrlConstants.getProfile(uid);
      final result = await http.get(url, headers: await buildHeaders());

      return Profile.fromJson(jsonDecode(result.body));
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<Announcement?> makeAnnouncement(String title, String content) async {
    try {
      final serializer = Announcement(
          title: title, content: content, createdAt: DateTime.now());
      final url = UrlConstants.announcements();
      final result = await http.post(url,
          headers: await buildHeaders(), body: jsonEncode(serializer.toJson()));

      return Announcement.fromJson(jsonDecode(result.body));
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<Activity> getActivities(String uid) async* {
    try {
      final url = UrlConstants.activities(uid: uid);
      final result = await http.get(url, headers: await buildHeaders());

      for (var activity in jsonDecode(result.body)) {
        yield Activity.fromJson(jsonDecode(activity));
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }
}

class CoreRepository {
  CoreApiProvider _api = CoreApiProvider();

  Future<List<Book>> getBooksByUser(String uid) async {
    return _api.getBooksByUser(uid).toList();
  }

  Future<List<Announcement>> getAnnouncements(String uid) async {
    return _api.getAnnouncements(uid).toList();
  }

  Future<Profile> getProfile(String uid) async {
    return _api.getProfile(uid);
  }

  Future<Announcement?> makeAnnouncement(String title, String message) async {
    return _api.makeAnnouncement(title, message);
  }

  Future<List<Activity>> getActivities(String uid) {
    return _api.getActivities(uid).toList();
  }
}
