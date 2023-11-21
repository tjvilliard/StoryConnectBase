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
  /// The current state of our reading resository, which contains all
  /// the data relevant to the reading UI.
  final ReadingRepository _repository;

  ///
  ReadingUIBloc({required ReadingRepository repository})
      : _repository = repository,
        super(ReadingUIState.initial()) {
    on<UpdateAllEvent>((event, emit) => updateUI(event, emit));
    on<ReadingLoadEvent>((event, emit) => loadEvent(event, emit));
    on<ToggleChapterOutlineEvent>((event, emit) => toggleChapterOutline(event, emit));
    on<ToggleFeedbackBarEvent>((event, emit) => toggleFeedbackBar(event, emit));
    on<ToggleAnnotationBarEvent>((event, emit) => toggleAnnotationBar(event, emit));
    on<ToggleToolbarEvent>((event, emit) => toggleToolbar(event, emit));
  }

  /// Gets the title of the book currently loaded by the reading UI.
  Future<String> _getBookTitle(int bookID) async {
    // Search the current state of our repository for our book.
    for (final book in _repository.books) {
      if (book.id == bookID) {
        return book.title;
      }
    }

    // Call the api again, and search the result for books.
    final List<Book> books = await _repository.getBooks();
    for (final book in books) {
      if (book.id == bookID) {
        return book.title;
      }
    }

    // If the book wasn't found, return Book not found Error.
    return "Error: Title not found";
  }

  /// Completes all tasks related to loading a book into the reading UI.
  Future<void> loadEvent(ReadingLoadEvent event, ReadingUIEmitter emit) async {
    emit(state.copyWith(loadingStruct: LoadingStruct.loading(true)));
    event.chapterBloc.add(LoadEvent());

    final title = await _getBookTitle(event.bookId);

    emit(state.copyWith(
      loadingStruct: LoadingStruct.loading(false),
      title: title,
    ));
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

  /// Updates the toggled state of the Toolbar Widget in the reading UI.
  void toggleToolbar(ReadingUIEvent event, ReadingUIEmitter emit) {
    emit(state.copyWith(toolbarShown: !state.toolbarShown));
  }
}
