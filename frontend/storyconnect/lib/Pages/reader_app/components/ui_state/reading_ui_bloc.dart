import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reader_app/components/chapter/state/chapter_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/components/serializers/library_entry_serializer.dart';
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
  ReadingRepository _repository = ReadingRepository();

  ///
  ReadingUIBloc({required ReadingRepository repository})
      : this._repository = repository,
        super(ReadingUIState.initial()) {
    on<UpdateAllEvent>((event, emit) => this.updateUI(event, emit));
    on<LibraryToggleEvent>((event, emit) => this.libraryToggle(event, emit));
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
    // Search the current state of our repository for our book.
    for (final book in this._repository.books) {
      if (book.id == bookID) {
        return book.title;
      }
    }

    // Call the api again, and search the result for books.
    final List<Book> books = await this._repository.getBooks();
    for (final book in books) {
      if (book.id == bookID) {
        return book.title;
      }
    }

    // If the book wasn't found, return Book not found Error.
    return "Error: Title not found";
  }

  /// Toggle whether the book should be in the library anymore or not.
  Future<void> libraryToggle(
      LibraryToggleEvent event, ReadingUIEmitter emit) async {
    Iterable<Library> entries =
        state.libBookIds.where((entry) => entry.book == event.bookId);

    if (entries.isEmpty) {
      this
          ._repository
          .addLibraryBook(LibraryEntrySerialzier.initial(event.bookId));
    } else {
      Library entry = entries.first;
      this._repository.removeLibraryBook(LibraryEntrySerialzier(
            id: entry.id,
            book: entry.book,
            status: entry.status,
            reader: entry.reader,
          ));
    }

    emit(
        state.copyWith(libBookIds: await this._repository.getLibraryEntries()));
  }

  /// Completes all tasks related to loading a book into the reading UI.
  Future<void> loadEvent(ReadingLoadEvent event, ReadingUIEmitter emit) async {
    emit(state
        .copyWith(loadingStruct: LoadingStruct.loading(true), libBookIds: []));
    event.chapterBloc.add(LoadEvent());

    final title = await _getBookTitle(event.bookId);
    final List<Library> libEntries = await this._repository.getLibraryEntries();

    emit(state.copyWith(
        loadingStruct: LoadingStruct.loading(false),
        title: title,
        libBookIds: libEntries));
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
