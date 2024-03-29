part of 'continuity_bloc.dart';

@freezed
class ContinuityState with _$ContinuityState {
  const factory ContinuityState({
    required LoadingStruct loadingStruct,
    required List<ContinuitySuggestion> continuities,
  }) = _ContinuityState;
  const ContinuityState._();

  // initial state
  factory ContinuityState.initial() {
    return ContinuityState(
      loadingStruct: LoadingStruct.loading(false),
      continuities: [],
    );
  }
}
