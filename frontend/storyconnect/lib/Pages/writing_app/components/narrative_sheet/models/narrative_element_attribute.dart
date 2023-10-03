part of 'narrative_element_models.dart';

@freezed
abstract class NarrativeElementAttribute with _$NarrativeElementAttribute {
  const factory NarrativeElementAttribute({
    required int elementId,
    String? attribute,
    required NarrativeElementAttributeType attributeType,
    required int confidence,
    required bool generated,
  }) = _NarrativeElementAttribute;

  factory NarrativeElementAttribute.fromJson(Map<String, dynamic> json) =>
      _$NarrativeElementAttributeFromJson(json);
}
