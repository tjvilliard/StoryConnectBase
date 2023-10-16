import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Services/url_service.dart';
import 'package:http/http.dart' as http;

part 'continuity_events.dart';
part 'continuity_state.dart';
part 'road_unblocker_repo.dart';
part 'continuity_bloc.freezed.dart';

typedef ContinuityEmitter = Emitter<ContinuityState>;

class ContinuityBloc extends Bloc<ContinuityEvent, ContinuityState> {
  late final ContinuityRepo _repo;

  ContinuityBloc({required ContinuityRepo repo})
      : super(ContinuityState.initial()) {
    _repo = repo;
    on<RecieveContinuityEvent>((event, emit) => recieveContinuity(event, emit));
  }

  recieveContinuity(RecieveContinuityEvent event, ContinuityEmitter emit) {
    emit(state.copyWith(loadingStruct: LoadingStruct.loading(true)));

    final continuity = _repo.getContinuity();

    emit(state.copyWith(loadingStruct: LoadingStruct.loading(false)));
  }
}
