part of 'continuity_models.dart';

@freezed
class ContinuitySuggestion with _$ContinuitySuggestion {
  const factory ContinuitySuggestion({
    required String description,
    required String uuid,
    required int chapterId,
    String? suggestionType,
  }) = _ContinuitySuggestion;

  factory ContinuitySuggestion.fromJson(Map<String, dynamic> json) =>
      _$ContinuitySuggestionFromJson(json);
}
