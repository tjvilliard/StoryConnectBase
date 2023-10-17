part of 'continuity_models.dart';

@freezed
class ContinuityResponse with _$ContinuityResponse {
  const factory ContinuityResponse({
    required List<ContinuitySuggestion> suggestions,
  }) = _ContinuityResponse;
  const ContinuityResponse._();

  factory ContinuityResponse.fromJson(Map<String, dynamic> json) =>
      _$ContinuityResponseFromJson(json);
}
