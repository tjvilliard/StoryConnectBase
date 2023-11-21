part of 'road_unblocker_bloc.dart';

// populate with dummy data for now
class RoadUnblockerApi {
  const RoadUnblockerApi();
  Future<RoadUnblockerResponse> submitUnblock(RoadUnblockerRequest request) async {
    final url = UrlConstants.roadUnblock();

    final result = await http
        .post(url, body: jsonEncode(request.toJson()), headers: await buildHeaders())
        .timeout(Duration(seconds: 300));
    return RoadUnblockerResponse.fromJson(jsonDecode(utf8.decode(result.bodyBytes)));
  }
}

class RoadUnblockerRepo {
  final RoadUnblockerApi api;
  RoadUnblockerRepo({this.api = const RoadUnblockerApi()});

  Future<RoadUnblockerResponse> submitUnblock(RoadUnblockerRequest request) async {
    return await api.submitUnblock(request);
  }
}
