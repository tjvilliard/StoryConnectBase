import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/state/feedback_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/reading/state/reading_bloc.dart';
import 'package:storyconnect/Repositories/reading_repository.dart';
import 'package:visual_editor/controller/controllers/editor-controller.dart';

part 'reading_ui_event.dart';
part 'reading_ui_state.dart';
part 'reading_ui_bloc.freezed.dart';

typedef ReadingUIEmitter = Emitter<ReadingUIState>;

/// Transforms Events related to the book reading UI and transforms the
/// state of the book reading UI Accordingly.
class ReadingUIBloc extends Bloc<ReadingUIEvent, ReadingUIState> {
  static double pageWidth = 800.0;
  static double pageHeight = 1050.0;

  /// The current state of our reading resository, which contains all
  /// the data relevant to the reading UI.
  final ReadingRepository _repo;

  ///
  ReadingUIBloc({required ReadingRepository repository})
      : _repo = repository,
        super(ReadingUIState.initial()) {
    on<UpdateAllEvent>((event, emit) => updateUI(event, emit));
    on<ReadingLoadEvent>((event, emit) => loadEvent(event, emit));
    on<ToggleChapterOutlineEvent>(
        (event, emit) => toggleChapterOutline(event, emit));
    on<ToggleFeedbackBarEvent>((event, emit) => toggleFeedbackBar(event, emit));
    on<ToggleAnnotationBarEvent>(
        (event, emit) => toggleAnnotationBar(event, emit));
  }

  /// Gets the title of the book currently loaded by the reading UI.
  Future<String> _getBookTitle(int bookID) async {
    // Query Backend for our book.

    // If the book wasn't found, return Book not found Error.
    Book? book = await _repo.getBook(bookID);

    if (book == null) {
      return "Error: Title not found";
    } else {
      return book.title;
    }
  }

  /// Completes all tasks related to loading a book into the reading UI.
  Future<void> loadEvent(ReadingLoadEvent event, ReadingUIEmitter emit) async {
    emit(state.copyWith(
        loadingStruct: LoadingStruct.loading(true), bookId: event.bookId));

    event.readingBloc.add(LoadReadingEvent(
      event.feedbackBloc,
      event.chapterIndex,
    ));

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
}
