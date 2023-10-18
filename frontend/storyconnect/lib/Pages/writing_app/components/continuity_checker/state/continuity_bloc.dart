// import 'dart:convert';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Pages/writing_app/components/continuity_checker/models/continuity_models.dart';
import 'package:storyconnect/Repositories/writing_repository.dart';
// import 'package:storyconnect/Services/url_service.dart';
// import 'package:http/http.dart' as http;

part 'continuity_events.dart';
part 'continuity_state.dart';
part 'continuity_bloc.freezed.dart';

typedef ContinuityEmitter = Emitter<ContinuityState>;

class ContinuityBloc extends Bloc<ContinuityEvent, ContinuityState> {
  late final WritingRepository _repo;

  ContinuityBloc({required WritingRepository repo})
      : super(ContinuityState.initial()) {
    _repo = repo;
    on<GenerateContinuitiesEvent>(
        (event, emit) => generateContinuities(event, emit));
    on<DismissContinuityEvent>((event, emit) => dismissContinuity(event, emit));
  }

  generateContinuities(
      GenerateContinuitiesEvent event, ContinuityEmitter emit) async {
    emit(state.copyWith(loadingStruct: LoadingStruct.loading(true)));

    final continuityResponse = await _repo.getContinuities(event.chapterId);

    emit(state.copyWith(
        loadingStruct: LoadingStruct.loading(false),
        continuities: continuityResponse?.suggestions ?? []));
  }

  dismissContinuity(
      DismissContinuityEvent event, Emitter<ContinuityState> emit) {
    final newContinuities = state.continuities
        .where((element) => element.uuid != event.uuid)
        .toList();
    emit(state.copyWith(continuities: newContinuities));
  }
}
