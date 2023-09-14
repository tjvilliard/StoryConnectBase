import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Repositories/writing_repository.dart';

part 'road_unblocker_events.dart';
part 'road_unblocker_state.dart';
part 'road_unblocker_repo.dart';
part 'road_unblocker_bloc.freezed.dart';

typedef RoadUnblockerEmitter = Emitter<RoadUnblockerState>;

class RoadUnblockerBloc extends Bloc<RoadUnblockerEvent, RoadUnblockerState> {
  late final WritingRepository _repo;

  RoadUnblockerBloc(WritingRepository repo)
      : super(RoadUnblockerState.initial()) {
    _repo = repo;
    on<PreloadChapterEvent>((event, emit) => preloadChapter(event, emit));
    on<OnGuidingQuestionChangedEvent>(
        (event, emit) => onGuidingQuestionChanged(event, emit));
    on<LoadSelectionEvent>((event, emit) => loadSelection(event, emit));
    on<SubmitUnblockEvent>((event, emit) => submitUnblock(event, emit));
    on<RecieveUnblockEvent>((event, emit) => recieveUnblock(event, emit));
  }

  preloadChapter(PreloadChapterEvent event, RoadUnblockerEmitter emit) {}

  onGuidingQuestionChanged(
      OnGuidingQuestionChangedEvent event, RoadUnblockerEmitter emit) {}

  submitUnblock(SubmitUnblockEvent event, RoadUnblockerEmitter emit) {}

  recieveUnblock(RecieveUnblockEvent event, RoadUnblockerEmitter emit) {}

  loadSelection(LoadSelectionEvent event, RoadUnblockerEmitter emit) {}
}
