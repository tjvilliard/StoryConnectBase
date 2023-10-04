part of 'narrative_element_models.dart';

@freezed
abstract class NarrativeElement with _$NarrativeElement {
  const factory NarrativeElement({
    required int bookId,
    required NarrativeElementType elementType,
    required List<NarrativeElementAttribute> attributes,
    required int userId,
    required String name,
    String? description,
    String? imageUrl,
    int? chapterId,
  }) = _NarrativeElement;
  const NarrativeElement._();

  // return sorted list of attributes by type name
  List<NarrativeElementAttribute> get sortedAttributes {
    final List<NarrativeElementAttribute> tempAttributes =
        List.from(attributes);
    return tempAttributes
      ..sort((a, b) => a.attributeType.name.compareTo(b.attributeType.name));
  }

  factory NarrativeElement.fromJson(Map<String, dynamic> json) =>
      _$NarrativeElementFromJson(json);
}
