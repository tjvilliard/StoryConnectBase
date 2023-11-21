import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Pages/writing_app/components/narrative_sheet/models/narrative_element_models.dart';
import 'package:storyconnect/Repositories/writing_repository.dart';

part 'narrative_sheet_events.dart';
part 'narrative_sheet_state.dart';
part 'narrative_sheet_bloc.freezed.dart';

typedef NarrativeSheetEmitter = Emitter<NarrativeSheetState>;

class NarrativeSheetBloc
    extends Bloc<NarrativeSheetEvent, NarrativeSheetState> {
  late final WritingRepository _repo;
  NarrativeSheetBloc(WritingRepository repo, int bookId)
      : super(NarrativeSheetState.initial(
          bookId: bookId,
        )) {
    _repo = repo;
    on<LoadNarrativeElements>(
        (event, emit) => loadNarrativeElements(event, emit));
    add(const LoadNarrativeElements());
  }

  loadNarrativeElements(
      LoadNarrativeElements event, NarrativeSheetEmitter emit) async {
    emit(state.copyWith(
      loading: LoadingStruct.message("Loading Characters"),
    ));

    final List<NarrativeElement> narrativeElements =
        await _repo.getNarrativeElements(state.bookId);

    emit(state.copyWith(
      loading: LoadingStruct.loading(false),
      narrativeElements: narrativeElements,
    ));
  }
}
