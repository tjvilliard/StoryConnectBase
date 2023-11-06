import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:replay_bloc/replay_bloc.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/writing_app/components/feedback/state/feedback_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/pages_repository.dart';

part 'writing_state.dart';
part 'writing_bloc.freezed.dart';
part 'writing_events.dart';

typedef WritingEmitter = Emitter<WritingState>;

class WritingBloc extends Bloc<WritingEvent, WritingState>
    with ReplayBlocMixin<WritingEvent, WritingState> {
  Timer? debounceTimer;

  late final BookProviderRepository _repo;
  WritingBloc(BookProviderRepository repository)
      : super(WritingState.initial()) {
    _repo = repository;
    on<AddChapterEvent>(
      (event, emit) => addChapter(event, emit),
      transformer: sequential(),
    );
    on<RemoveChapterEvent>(
      (event, emit) => removeChapter(event, emit),
    );
    on<SwitchChapterEvent>(
      (event, emit) => switchChapter(event, emit),
    );
    on<UpdateChapterEvent>((event, emit) => updateChapter(event, emit),
        transformer: sequential());

    on<FeedbackLoadEvent>((event, emit) => loadEvent(event, emit));

    on<WritingUndoCommandEvent>((event, emit) => undoCommand(event, emit));
    on<WritingRedoCommandEvent>((event, emit) => redoCommand(event, emit));

    on<_UpdateChapterHelperEvent>(
        (event, emit) => _updateChapterHelper(event.event, emit));
  }

  int get currentChapterId => state.chapterNumToID[state.currentIndex]!;

  Future<void> addChapter(AddChapterEvent event, WritingEmitter emit) async {
    emit.call(state.copyWith(
        loadingStruct: LoadingStruct.message("Creating Chapter")));

    Map<int, String> chapters = Map.from(state.chapters);

    final sortedChapterNum = chapters.keys.toList();
    sortedChapterNum.sort((b, a) => a.compareTo(b));
    final newChapterNum = sortedChapterNum.first + 1;
    print(state.loadingStruct.isLoading);
    final result = await _repo.createChapter(newChapterNum);
    if (result != null) {
      state.chapterNumToID[newChapterNum] = result.id;
      chapters[newChapterNum] = "";
      emit.call(state.copyWith(
          chapters: chapters, loadingStruct: LoadingStruct.loading(false)));
    } else {
      emit.call(state.copyWith(loadingStruct: LoadingStruct.loading(false)));
    }
  }

  void removeChapter(RemoveChapterEvent event, WritingEmitter emit) {
    Map<int, String> chapters = Map.from(state.chapters);
    chapters.remove(event.chapterNum);
    emit(
      state.copyWith(
          chapters: chapters, loadingStruct: LoadingStruct.loading(false)),
    );
  }

  void switchChapter(SwitchChapterEvent event, WritingEmitter emit) async {
    emit(state.copyWith(
      currentIndex: event.chapterToSwitchTo,
    ));
  }

  void updateChapter(UpdateChapterEvent event, WritingEmitter emit) async {
    if (debounceTimer != null && debounceTimer!.isActive) {
      debounceTimer!.cancel();
    }
    debounceTimer = Timer(Duration(milliseconds: 250), () {
      add(_UpdateChapterHelperEvent(event: event));
    });
  }

  void _updateChapterHelper(
      UpdateChapterEvent event, WritingEmitter emit) async {
    Map<int, String> chapters = Map.from(state.chapters);
    chapters[state.currentIndex] = event.text;

    emit(state.copyWith(chapters: chapters));

    _repo.updateChapter(
      chapterId: state.chapterNumToID[state.currentIndex] ?? -1,
      number: state.currentIndex,
      text: chapters[state.currentIndex]!,
    );
  }

  // helper function to load chapters into expected format
  Map<int, String> parseChapters(List<Chapter> chapters) {
    Map<int, String> parsedChapters = {};
    for (Chapter chapter in chapters) {
      state.chapterNumToID[chapter.number] = chapter.id;
      parsedChapters[chapter.number] = chapter.chapterContent;
    }
    return parsedChapters;
  }

  void loadEvent(FeedbackLoadEvent event, WritingEmitter emit) async {
    emit(state.copyWith(loadingStruct: LoadingStruct.message("Loading Book")));
    final unParsedChapters = await _repo.getChapters();

    final chapters = parseChapters(unParsedChapters);

    emit(state.copyWith(
        chapters: chapters, loadingStruct: LoadingStruct.loading(false)));
    clearHistory();

    final chapterId = state.chapterNumToID[state.currentIndex]!;

    event.feedbackBloc.add(LoadChapterFeedback(chapterId));
  }

  /// Undoes the last command. If the command is a switch chapter command, it will switch to the chapter that was switched from,
  /// and then perform the undo command. Multiple chapter switches in a row will be undone in reverse order.
  undoCommand(WritingUndoCommandEvent event, WritingEmitter emit) {
    undo();
  }

  redoCommand(WritingRedoCommandEvent event, WritingEmitter emit) {
    redo();
  }
}
