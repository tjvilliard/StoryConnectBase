part of 'road_unblocker_bloc.dart';

// populate with dummy data for now
class RoadUnblockerApi {
  const RoadUnblockerApi();
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

class RoadUnblockerRepo {
  final RoadUnblockerApi api;
  RoadUnblockerRepo({this.api = const RoadUnblockerApi()});

  Future<RoadUnblockerResponse> submitUnblock(
      RoadUnblockerRequest request) async {
    return await api.submitUnblock(request);
  }
}
