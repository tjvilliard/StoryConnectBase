import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';

part 'road_unblocker_events.dart';
part 'road_unblocker_state.dart';
part 'road_unblocker_repo.dart';
part 'road_unblocker_bloc.freezed.dart';

typedef RoadUnblockerEmitter = Emitter<RoadUnblockerState>;

class RoadUnblockerBloc extends Bloc<RoadUnblockerEvent, RoadUnblockerState> {
  late final RoadUnblockerRepo _repo;

  RoadUnblockerBloc(
      {required RoadUnblockerRepo repo, required String chapterContent})
      : super(RoadUnblockerState.initial(currentChapterText: chapterContent)) {
    _repo = repo;
    on<UpdateChapterEvent>((event, emit) => updateChapter(event, emit));
    on<OnGuidingQuestionChangedEvent>(
        (event, emit) => onGuidingQuestionChanged(event, emit));
    on<LoadSelectionEvent>((event, emit) => loadSelection(event, emit));
    on<SubmitUnblockEvent>((event, emit) => submitUnblock(event, emit));
    on<RecieveUnblockEvent>((event, emit) => recieveUnblock(event, emit));
    on<ClearUnblockEvent>((event, emit) => clearUnblock(event, emit));
  }

  updateChapter(UpdateChapterEvent event, RoadUnblockerEmitter emit) {
    emit(state.copyWith(chapter: event.chapter));
  }

  onGuidingQuestionChanged(
      OnGuidingQuestionChangedEvent event, RoadUnblockerEmitter emit) {
    emit(state.copyWith(question: event.question));
  }

  submitUnblock(SubmitUnblockEvent event, RoadUnblockerEmitter emit) async {
    emit(state.copyWith(
        loadingStruct: LoadingStruct.message("Building some suggestions")));

    final finalQuestion =
        state.question ?? "Can I get some general help with this?";
    final finalSelection = state.selection ?? "";

    final response = await _repo.submitUnblock(RoadUnblockerRequest(
      chapter: state.chapter,
      question: finalQuestion,
      selection: finalSelection,
    ));

    add(RecieveUnblockEvent(response: response));
  }

  recieveUnblock(RecieveUnblockEvent event, RoadUnblockerEmitter emit) {
    final responses = List<RoadUnblockerResponse>.from(state.responses);
    responses.add(event.response);

    emit(state.copyWith(responses: responses));
  }

  loadSelection(LoadSelectionEvent event, RoadUnblockerEmitter emit) {
    emit(state.copyWith(
        selection:
            state.chapter.substring(event.startOffset, event.endOffset)));
  }

  clearUnblock(ClearUnblockEvent event, Emitter<RoadUnblockerState> emit) {
    emit(state.copyWith(responses: [], question: null, selection: null));
  }
}
