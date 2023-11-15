part of 'road_unblocker_models.dart';

@freezed
class RoadUnblockerSuggestion with _$RoadUnblockerSuggestion {
  factory RoadUnblockerSuggestion({
    // This field stores a locally generated UUID and is not serialized to JSON
    required String uid, // <- Local only UUID
    @JsonKey(name: 'offset_start') int? offsetStart,
    @JsonKey(name: 'offset_end') int? offsetEnd,
    required String suggestion,
    String? original,
    @JsonKey(name: 'suggested_change') required String suggestedChange,
  }) = _RoadUnblockerSuggestion;
  const RoadUnblockerSuggestion._();

  bool isAddition() {
    return original == null || original!.isEmpty;
  }

  factory RoadUnblockerSuggestion.fromJson(Map<String, dynamic> json) =>
      _$RoadUnblockerSuggestionFromJson(json);
}
