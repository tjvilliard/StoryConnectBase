part of 'narrative_sheet_bloc.dart';

abstract class NarrativeSheetEvent {
  const NarrativeSheetEvent();
}

class LoadNarrativeElements extends NarrativeSheetEvent {
  const LoadNarrativeElements();
}

class GenerateNarrativeSheet extends NarrativeSheetEvent {
  const GenerateNarrativeSheet();
}

class RecieveNarrativeElements extends NarrativeSheetEvent {
  final List<NarrativeElement> narrativeElements;
  const RecieveNarrativeElements(this.narrativeElements);
}
