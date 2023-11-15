import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Services/url_service.dart';

import 'package:http/http.dart' as http;
part 'firebase_helper.freezed.dart';
part 'firebase_helper.g.dart';

class FirebaseHelper {
  static Future<String?> getDisplayName(int uid) async {
    try {
      if (uid == 0) {
        return "Anonymous";
      }
      final url = UrlConstants.getDisplayName(uid);
      final result = await http.get(url, headers: await buildHeaders());
      return UsernameIdConversionSerializer.fromJson(jsonDecode(result.body))
          .username;
    } catch (e) {
      print(e);
      return null;
    }
  }
}

@freezed
class UsernameIdConversionSerializer with _$UsernameIdConversionSerializer {
  const factory UsernameIdConversionSerializer({
    required String username,
  }) = _UsernameIdConversionSerializer;

  factory UsernameIdConversionSerializer.fromJson(Map<String, dynamic> json) =>
      _$UsernameIdConversionSerializerFromJson(json);
}
