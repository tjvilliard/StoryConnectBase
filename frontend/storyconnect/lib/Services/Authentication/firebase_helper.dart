import 'package:storyconnect/Services/url_service.dart';

import 'package:http/http.dart' as http;

class FirebaseHelper {
  static Future<String?> getDisplayName(String uid) async {
    final Uri url = UrlConstants.getDisplayName(uid);

    final response = await http.get(url, headers: await buildHeaders());

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }
}
