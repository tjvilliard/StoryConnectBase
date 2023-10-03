part of 'narrative_element_models.dart';

@freezed
abstract class NarrativeElement with _$NarrativeElement {
  const factory NarrativeElement({
    required int bookId,
    required NarrativeElementType elementType,
    required List<NarrativeElementAttribute> attributes,
    required int userId,
    String? name,
    String? description,
    String? imageUrl,
    int? chapterId,
  }) = _NarrativeElement;

  factory NarrativeElement.fromJson(Map<String, dynamic> json) =>
      _$NarrativeElementFromJson(json);
}
