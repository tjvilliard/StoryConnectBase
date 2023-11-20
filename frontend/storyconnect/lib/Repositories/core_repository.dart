import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:storyconnect/Pages/registration/models/registration_models.dart';
import 'package:storyconnect/Pages/writer_profile/serializers/writer_profile_serializers.dart';
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

  Future<GenericResponse?> verifyDisplayNameUniqueness(DisplayNameSerializer serializer) async {
    try {
      final url = UrlConstants.verifyDisplayNameUniqueness();
      final result = await http.post(url, headers: await buildHeaders(), body: jsonEncode(serializer.toJson()));
      return GenericResponse.fromJson(jsonDecode(result.body));
    } catch (e) {
      print(e);
      return null;
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
      final url = UrlConstants.profiles(uid: uid);
      final result = await http.get(url, headers: await buildHeaders());
      return Profile.fromJson(jsonDecode(result.body));
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<Announcement?> makeAnnouncement(String title, String content) async {
    try {
      final serializer = Announcement(title: title, content: content, createdAt: DateTime.now());
      final url = UrlConstants.announcements();
      final result = await http.post(url, headers: await buildHeaders(), body: jsonEncode(serializer.toJson()));

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

  Future<Profile?> updateProfile(Profile profile) async {
    try {
      final String? uid = FirebaseAuth.instance.currentUser!.uid;
      if (uid == null) throw Exception("User not logged in");

      final url = UrlConstants.profiles(uid: uid);
      final response = await http.patch(url, headers: await buildHeaders(), body: jsonEncode(profile.toJson()));
      return Profile.fromJson(jsonDecode(response.body));
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Profile?> updateProfileImage(String encodedImage) async {
    try {
      final String? uid = FirebaseAuth.instance.currentUser!.uid;
      if (uid == null) throw Exception("User not logged in");

      final serializer = ProfileImageSerializer(image: encodedImage);

      final url = UrlConstants.updateProfileImage();
      return http
          .post(url, headers: await buildHeaders(), body: jsonEncode(serializer.toJson()))
          .then((value) => Profile.fromJson(jsonDecode(value.body)));
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<GenericResponse> deleteProfileImage() async {
    try {
      final String? uid = FirebaseAuth.instance.currentUser!.uid;
      if (uid == null) throw Exception("User not logged in");

      final url = UrlConstants.updateProfileImage();
      final result = await http.delete(url, headers: await buildHeaders());
      return GenericResponse.fromJson(jsonDecode(result.body));
    } catch (e) {
      print(e);
      return GenericResponse(success: false, message: "Failed to delete profile image");
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

  Future<Profile?> updateProfile(Profile profile) {
    return _api.updateProfile(profile);
  }

  Future<Profile?> updateProfileImage(Uint8List image) async {
    final encodedImage = await compute(base64Encode, image);

    return _api.updateProfileImage(encodedImage);
  }

  Future<GenericResponse> deleteProfileImage() async {
    return _api.deleteProfileImage();
  }

  Future<bool> verifyDisplayNameUniqueness(String displayName) async {
    final serializer = DisplayNameSerializer(displayName: displayName);
    final response = await _api.verifyDisplayNameUniqueness(serializer);
    return response?.success ?? false;
  }
}
