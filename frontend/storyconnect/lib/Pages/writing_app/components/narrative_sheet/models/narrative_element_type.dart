part of 'narrative_element_models.dart';

@freezed
abstract class NarrativeElementType with _$NarrativeElementType {
  const factory NarrativeElementType({
    required int userId,
    required String name,
  }) = _NarrativeElementType;

  factory NarrativeElementType.fromJson(Map<String, dynamic> json) =>
      _$NarrativeElementTypeFromJson(json);
}
