part of 'continuity_models.dart';

@freezed
class ContinuitySuggestion with _$ContinuitySuggestion {
  const factory ContinuitySuggestion({
    required String content,
    required String uuid,
    @JsonKey(name: "chapter_id") required int chapterId,
    int? startChar,
    String? suggestionType,
  }) = _ContinuitySuggestion;

  factory ContinuitySuggestion.fromJson(Map<String, dynamic> json) =>
      _$ContinuitySuggestionFromJson(json);
}
