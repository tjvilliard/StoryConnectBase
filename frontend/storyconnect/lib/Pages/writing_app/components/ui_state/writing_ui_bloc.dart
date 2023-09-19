import 'package:bloc/bloc.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Pages/writing_app/components/chapter/chapter_bloc.dart';
import 'package:storyconnect/Repositories/writing_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'writing_ui_bloc.freezed.dart';
part 'writing_ui_state.dart';
part 'writing_ui_event.dart';

class WritingLoadEvent extends WritingUIEvent {
  final int bookId;
  final ChapterBloc chapterBloc;
  WritingLoadEvent({
    required this.bookId,
    required this.chapterBloc,
  });
}

typedef WritingUIEmiter = Emitter<WritingUIState>;

class WritingUIBloc extends Bloc<WritingUIEvent, WritingUIState> {
  WritingRepository repository = WritingRepository();
  WritingUIBloc({required this.repository}) : super(WritingUIState.initial()) {
    on<UpdateAllEvent>((event, emit) => updateUI(event, emit));
    on<WritingLoadEvent>((event, emit) => loadEvent(event, emit));
    on<ToggleChapterOutlineEvent>(
        (event, emit) => toggleChapterOutline(event, emit));
    on<ToggleCommentsUIEvent>((event, emit) => toggleCommentsUI(event, emit));
    on<ToggleRoadUnblockerEvent>(
        (event, emit) => toggleRoadUnblocker(event, emit));
  }
  updateUI(UpdateAllEvent event, WritingUIEmiter emit) {
    emit(event.status);
  }

  Future<String> _getBookTitle(int bookId) async {
    for (final book in repository.books) {
      if (book.id == bookId) {
        return book.title;
      }
    }
    final books = await repository.getBooks();
    for (final book in books) {
      if (book.id == bookId) {
        return book.title;
      }
    }
    return "Error: Title not found";
  }

  Future<void> loadEvent(WritingLoadEvent event, WritingUIEmiter emit) async {
    emit(state.copyWith(loadingStruct: LoadingStruct.loading(true)));
    event.chapterBloc.add(LoadEvent());

    final title = await _getBookTitle(event.bookId);

    emit(state.copyWith(
        loadingStruct: LoadingStruct.loading(false), title: title));
  }

  void toggleChapterOutline(WritingUIEvent event, WritingUIEmiter emit) {
    emit(state.copyWith(chapterOutlineShown: !state.chapterOutlineShown));
  }

  void toggleCommentsUI(WritingUIEvent event, WritingUIEmiter emit) {
    emit(state.copyWith(
        feedbackUIshown: !state.feedbackUIshown, roadUnblockerShown: false));
  }

  void toggleRoadUnblocker(
      ToggleRoadUnblockerEvent event, Emitter<WritingUIState> emit) {
    emit(state.copyWith(
        roadUnblockerShown: !state.roadUnblockerShown, feedbackUIshown: false));
  }
}
