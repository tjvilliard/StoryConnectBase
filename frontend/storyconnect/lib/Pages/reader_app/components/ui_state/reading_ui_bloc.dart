import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reader_app/components/chapter/state/chapter_bloc.dart';
import 'package:storyconnect/Repositories/reading_repository.dart';

part 'reading_ui_event.dart';
part 'reading_ui_state.dart';
part 'reading_ui_bloc.freezed.dart';

typedef ReadingUIEmitter = Emitter<ReadingUIState>;

/// Transforms Events related to the book reading UI and transforms the
/// state of the book reading UI Accordingly.
class ReadingUIBloc extends Bloc<ReadingUIEvent, ReadingUIState> {
  ReadingRepository repository = ReadingRepository();
  ReadingUIBloc({required this.repository}) : super(ReadingUIState.initial()) {
    on<UpdateAllEvent>((event, emit) => this.updateUI(event, emit));
    on<ReadingLoadEvent>((event, emit) => this.loadEvent(event, emit));
    on<ToggleChapterOutlineEvent>(
        (event, emit) => toggleChapterOutline(event, emit));
    on<ToggleFeedbackBarEvent>(
        (event, emit) => this.toggleFeedbackBar(event, emit));
    on<ToggleAnnotationBarEvent>(
        (event, emit) => this.toggleAnnotationBar(event, emit));
    on<ToggleToolbarEvent>((event, emit) => this.toggleToolbar(event, emit));
  }

  /// Gets the title of the book currently loaded by the reading UI.
  Future<String> _getBookTitle(int bookID) async {
    for (final book in repository.books) {
      if (book.id == bookID) {
        return book.title;
      }
    }
    final List<Book> books = await repository.getBooks();
    for (final book in books) {
      if (book.id == bookID) {
        return book.title;
      }
    }
    return "Error: Title not found";
  }

  /// Completes all tasks related to loading a book into the reading UI.
  Future<void> loadEvent(ReadingLoadEvent event, ReadingUIEmitter emit) async {
    emit(state.copyWith(loadingStruct: LoadingStruct.loading(true)));
    event.chapterBloc.add(LoadEvent());

    final title = await _getBookTitle(event.bookId);

    emit(state.copyWith(
        loadingStruct: LoadingStruct.loading(false), title: title));
  }

  /// Completes the task of updating the whole state of the reading UI.
  updateUI(UpdateAllEvent event, ReadingUIEmitter emit) {
    emit(event.state);
  }

  /// Updates the state of the Chapter Outline Widget in the reading UI.
  void toggleChapterOutline(ReadingUIEvent event, ReadingUIEmitter emit) {
    emit(state.copyWith(chapterOutlineShown: !state.chapterOutlineShown));
  }

  /// Updates the toggled state of the Feedback Widget in the reading UI.
  void toggleFeedbackBar(ReadingUIEvent event, ReadingUIEmitter emit) {
    emit(state.copyWith(feedbackBarShown: !state.feedbackBarShown));
  }

  /// Updates the toggled state of the Annotation Widget in the reading UI.
  void toggleAnnotationBar(ReadingUIEvent event, ReadingUIEmitter emit) {
    emit(state.copyWith(annotationBarShown: !state.annotationBarShown));
  }

  ///
  void toggleToolbar(ReadingUIEvent event, ReadingUIEmitter emit) {
    emit(state.copyWith(toolbarShown: !state.toolbarShown));
  }
}
