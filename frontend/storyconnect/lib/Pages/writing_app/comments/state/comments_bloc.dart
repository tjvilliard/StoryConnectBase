import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Repositories/writing_repository.dart';

part 'comments_event.dart';
part 'comments_state.dart';
part 'comments_bloc.freezed.dart';

typedef CommentsEmitter = Emitter<CommentsState>;

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  late final WritingRepository _repo;
  CommentsBloc(WritingRepository repo) : super(CommentsState.initial()) {
    _repo = repo;
    on<LoadChapterComments>((event, emit) => loadChapterComments(event, emit));
  }

  Stream<void> loadChapterComments(
      LoadChapterComments event, CommentsEmitter emit) async* {
    emit(CommentsState(
      loadingStruct: LoadingStruct.loading(true),
    ));

    final commentsState = state.comments ?? {};

    final List<Comment> comments =
        await _repo.getChapterComments(event.chapterId);

    // remove all the comments for the newly fetched chapter (if they exist) from the oldComments storage
    commentsState.remove(event.chapterId);

    // add the newly fetched comments to the oldComments storage
    commentsState[event.chapterId] = comments;

    emit(CommentsState(
      loadingStruct: LoadingStruct.loading(false),
      comments: commentsState,
    ));
  }
}
