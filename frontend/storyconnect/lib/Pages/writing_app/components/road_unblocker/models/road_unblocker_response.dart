part of 'road_unblocker_models.dart';

@freezed
class RoadUnblockerResponse with _$RoadUnblockerResponse {
  factory RoadUnblockerResponse({
    required String uid,
    required String message,
    required List<RoadUnblockerSuggestion> suggestions,
  }) = _RoadUnblockerResponse;
  const RoadUnblockerResponse._();

  factory RoadUnblockerResponse.fromJson(Map<String, dynamic> json) =>
      _$RoadUnblockerResponseFromJson(json);
}
