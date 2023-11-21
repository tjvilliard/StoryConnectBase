part of 'road_unblocker_models.dart';

@freezed
class RoadUnblockerRequest with _$RoadUnblockerRequest {
  const factory RoadUnblockerRequest({
    @JsonKey(name: 'chapter_id') required int chapterID,
    required String selection,
    required String question,
  }) = _RoadUnblockerRequest;
  const RoadUnblockerRequest._();

  factory RoadUnblockerRequest.fromJson(Map<String, dynamic> json) =>
      _$RoadUnblockerRequestFromJson(json);
}
