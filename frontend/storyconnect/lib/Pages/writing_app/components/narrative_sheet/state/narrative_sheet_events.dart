part of 'narrative_sheet_bloc.dart';

abstract class NarrativeSheetEvent {
  const NarrativeSheetEvent();
}

class LoadNarrativeElements extends NarrativeSheetEvent {
  const LoadNarrativeElements();
}
