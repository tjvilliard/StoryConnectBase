import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Repositories/reading_repository.dart';

part 'feedback_event.dart';
part 'feedback_state.dart';
part 'feedback_bloc.freezed.dart';

typedef FeedbackEmitter = Emitter<FeedbackState>;

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  // TODO: implement repo
  // ignore: unused_field
  late final ReadingRepository _repo;

  /// Maps Events
  FeedbackBloc(ReadingRepository repo) : super(FeedbackState.initial()) {
    this._repo = repo;
    // load chapter comments
    // feedback type changed - make annotation, make comment, make suggestion
    on<LoadChapterComments>((event, emit) => loadChapterComments(event, emit));
  }

  Stream<void> loadChapterComments(
      LoadChapterComments event, FeedbackEmitter emit) async* {}
}
