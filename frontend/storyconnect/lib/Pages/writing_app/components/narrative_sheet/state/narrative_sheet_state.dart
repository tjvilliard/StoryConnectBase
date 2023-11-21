part of 'narrative_sheet_bloc.dart';

@freezed
class NarrativeSheetState with _$NarrativeSheetState {
  const factory NarrativeSheetState({
    required int bookId,
    required LoadingStruct loading,
    required List<NarrativeElement> narrativeElements,
  }) = _NarrativeSheetState;
  const NarrativeSheetState._();

  // get the narrative element types as a list of their names (since it will be dynamic)
  List<String> get narrativeElementTypes {
    return narrativeElements.map((e) => e.elementType.name).toList();
  }

  List<NarrativeElement> get sortedNarrativeElements {
    var sortedList = List<NarrativeElement>.from(narrativeElements);
    sortedList.sort((a, b) => a.elementType.name.compareTo(b.elementType.name));
    return sortedList;
  }

  // initial state
  factory NarrativeSheetState.initial({required int bookId}) {
    return NarrativeSheetState(
      bookId: bookId,
      loading: LoadingStruct.loading(true),
      narrativeElements: [],
    );
  }
}
