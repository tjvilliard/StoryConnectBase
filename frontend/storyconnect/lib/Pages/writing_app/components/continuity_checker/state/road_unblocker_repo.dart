part of 'continuity_bloc.dart';

// populate with dummy data for now
class ContinuityCheckerApi {
  const ContinuityCheckerApi();
  Future<RoadUnblockerResponse> submitUnblock(
      RoadUnblockerRequest request) async {
    final url = UrlContants.roadUnblock();
    String authToken =
        (await FirebaseAuth.instance.currentUser!.getIdToken(true)) as String;
    final result = await http.post(url,
        body: jsonEncode(request.toJson()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $authToken'
        });
    return RoadUnblockerResponse.fromJson(jsonDecode(result.body));
  }
}

class ContinuityRepo {
  final ContinuityCheckerApi api;
  ContinuityRepo({this.api = const ContinuityCheckerApi()});

  Future<void> getContinuity() async {}
}
