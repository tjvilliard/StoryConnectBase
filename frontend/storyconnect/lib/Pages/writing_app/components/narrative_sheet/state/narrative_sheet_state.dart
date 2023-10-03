part of 'narrative_sheet_bloc.dart';

@freezed
class NarrativeSheetState with _$NarrativeSheetState {
  const factory NarrativeSheetState({
    required int bookId,
    required LoadingStruct loading,
    required List<NarrativeElement> narrativeElements,
  }) = _NarrativeSheetState;
  const NarrativeSheetState._();

  // initial state
  factory NarrativeSheetState.initial({required int bookId}) {
    return NarrativeSheetState(
      bookId: bookId,
      loading: LoadingStruct.loading(true),
      narrativeElements: [],
    );
  }
}
