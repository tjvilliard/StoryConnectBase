import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Pages/writing_app/components/road_unblocker/models/road_unblocker_models.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/_state/writing_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:storyconnect/Services/url_service.dart';

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
    on<UnblockerUpdateChapterEvent>(
        (event, emit) => updateChapter(event, emit));
    on<OnGuidingQuestionChangedEvent>(
        (event, emit) => onGuidingQuestionChanged(event, emit));
    on<LoadSelectionEvent>((event, emit) => loadSelection(event, emit));
    on<SubmitUnblockEvent>((event, emit) => submitUnblock(event, emit));
    on<RecieveUnblockEvent>((event, emit) => recieveUnblock(event, emit));
    on<ClearUnblockEvent>((event, emit) => clearUnblock(event, emit));
    on<AcceptSuggestionEvent>((event, emit) => acceptSuggestion(event, emit));
    on<RejectSuggestionEvent>((event, emit) => rejectSuggestion(event, emit));
  }

  updateChapter(UnblockerUpdateChapterEvent event, RoadUnblockerEmitter emit) {
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
      chapterID: event.chapterID,
      question: question,
      selection: finalSelection,
    ));

    add(RecieveUnblockEvent(response: response));
  }

  recieveUnblock(RecieveUnblockEvent event, RoadUnblockerEmitter emit) {
    final responses = List<RoadUnblockerResponse>.from(state.responses);
    responses.add(event.response);

    emit(state.copyWith(
        responses: responses, loadingStruct: LoadingStruct.loading(false)));
  }

  loadSelection(LoadSelectionEvent event, RoadUnblockerEmitter emit) {
    emit(state.copyWith(
        selection:
            state.chapter.substring(event.startOffset, event.endOffset)));
  }

  clearUnblock(ClearUnblockEvent event, RoadUnblockerEmitter emit) {
    emit(state.copyWith(responses: [], question: null, selection: null));
  }

  // for now, just remove them from the responses
  acceptSuggestion(AcceptSuggestionEvent event, RoadUnblockerEmitter emit) {
    final responses = List<RoadUnblockerResponse>.from(state.responses);
    final response =
        responses.firstWhere((element) => element.uid == event.responseLocalId);
    final suggestions =
        List<RoadUnblockerSuggestion>.from(response.suggestions);

    // final suggestion =
    //     suggestions.firstWhere((element) => element.uid == event.localId);

    // // add a chapter change to the chapter bloc with the new suggestion
    // String currentChapterText = event.WritingBloc.state.currentChapterText;

    // final chapterText = currentChapterText.replaceRange(suggestion.offsetStart,
    //     suggestion.offsetEnd, suggestion.suggestedChange);

    // event.WritingBloc.add(UpdateChapterEvent(text: chapterText));

    suggestions.removeWhere((element) => element.uid == event.localId);
    responses.removeWhere((element) => element.uid == event.responseLocalId);
    responses.add(response.copyWith(suggestions: suggestions));
    emit(state.copyWith(responses: _removeEmptyResponses(responses)));
  }

  rejectSuggestion(RejectSuggestionEvent event, RoadUnblockerEmitter emit) {
    final responses = List<RoadUnblockerResponse>.from(state.responses);
    final response =
        responses.firstWhere((element) => element.uid == event.responseLocalId);
    final suggestions =
        List<RoadUnblockerSuggestion>.from(response.suggestions);
    suggestions.removeWhere((element) => element.uid == event.localId);
    responses.removeWhere((element) => element.uid == event.responseLocalId);
    responses.add(response.copyWith(suggestions: suggestions));
    emit(state.copyWith(responses: _removeEmptyResponses(responses)));
  }

  List<RoadUnblockerResponse> _removeEmptyResponses(
      List<RoadUnblockerResponse> responses) {
    responses.removeWhere((element) => element.suggestions.isEmpty);
    return responses;
  }
}
