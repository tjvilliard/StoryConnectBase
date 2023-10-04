part of 'narrative_element_models.dart';

@freezed
abstract class NarrativeElementAttribute with _$NarrativeElementAttribute {
  const factory NarrativeElementAttribute({
    required int elementId,
    required String attribute,
    required NarrativeElementAttributeType attributeType,
    required double confidence,
    required bool generated,
  }) = _NarrativeElementAttribute;

  factory NarrativeElementAttribute.fromJson(Map<String, dynamic> json) =>
      _$NarrativeElementAttributeFromJson(json);
}
