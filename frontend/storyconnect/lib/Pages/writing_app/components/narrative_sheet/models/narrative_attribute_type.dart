part of 'narrative_element_models.dart';

@freezed
abstract class NarrativeElementAttributeType
    with _$NarrativeElementAttributeType {
  const factory NarrativeElementAttributeType({
    required int userId,
    required String name,
    @JsonKey(name: 'applicable_to') required NarrativeElementType applicableTo,
  }) = _NarrativeElementAttributeType;

  factory NarrativeElementAttributeType.fromJson(Map<String, dynamic> json) =>
      _$NarrativeElementAttributeTypeFromJson(json);
}
