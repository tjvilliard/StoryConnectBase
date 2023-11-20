import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';

import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Models/text_annotation/text_selection.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/_state/writing_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/feedback/state/feedback_bloc.dart';
import 'package:storyconnect/Repositories/writing_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:visual_editor/visual-editor.dart';

part 'writing_ui_bloc.freezed.dart';
part 'writing_ui_state.dart';
part 'writing_ui_event.dart';

typedef WritingUIEmiter = Emitter<WritingUIState>;

class WritingUIBloc extends Bloc<WritingUIEvent, WritingUIState> {
  static Timer? timer; // Static variable to maintain state between calls to highlight

  static double pageWidth = 800.0;
  static double pageHeight = 1050.0;

  WritingRepository repository = WritingRepository();
  WritingUIBloc({required this.repository}) : super(WritingUIState.initial()) {
    on<UpdateAllEvent>((event, emit) => updateUI(event, emit));
    on<WritingLoadEvent>((event, emit) => loadEvent(event, emit));
    on<ToggleChapterOutlineEvent>((event, emit) => toggleChapterOutline(event, emit));
    on<ToggleFeedbackUIEvent>((event, emit) => toggleFeedback(event, emit));
    on<ToggleRoadUnblockerEvent>((event, emit) => toggleRoadUnblocker(event, emit));
    on<ToggleContinuityCheckerEvent>((event, emit) => toggleContinuityChecker(event, emit));
    on<HighlightEvent>((event, emit) => highlight(event, emit));
    on<RemoveHighlightEvent>((event, emit) => removeHighlight(event, emit));

    on<DeleteBookEvent>((event, emit) => deleteBook(event, emit));
    on<UpdateBookEvent>((event, emit) => updateBook(event, emit));

    on<UpdateBookLanguageEvent>((event, emit) => updateBookLanguage(event, emit));
    on<UpdateBookTitleEvent>((event, emit) => updateBookTitle(event, emit));
    on<UpdateBookSynopsisEvent>((event, emit) => updateBookDescription(event, emit));
    on<UpdateBookTargetAudienceEvent>((event, emit) => updateBookTargetAudience(event, emit));
    on<UpdateBookCopyrightEvent>((event, emit) => updateBookCopyright(event, emit));

    on<SelectUpdatedBookCoverEvent>((event, emit) => selectUpdatedBookCover(event, emit));
    on<ClearUpdateBookEvent>((event, emit) => clearUpdateBook(event, emit));
  }
  void updateUI(UpdateAllEvent event, WritingUIEmiter emit) {
    emit(event.status);
  }

  Future<Book?> _getBook(int bookId) async {
    for (final book in repository.books) {
      if (book.id == bookId) {
        return book;
      }
    }
    final books = await repository.getBooks();
    for (final book in books) {
      if (book.id == bookId) {
        return book;
      }
    }
    return null;
  }

  Future<void> loadEvent(WritingLoadEvent event, WritingUIEmiter emit) async {
    emit(state.copyWith(loadingStruct: LoadingStruct.loading(true), bookId: event.bookId));

    event.writingBloc.add(LoadWritingEvent(
      event.feedbackBloc,
    ));

    final Book? book = await _getBook(event.bookId);

    if (book == null) {
      emit(state.copyWith(loadingStruct: LoadingStruct.errorMessage("Book not found")));
      return;
    }

    emit(state.copyWith(
        loadingStruct: LoadingStruct.loading(false),
        book: book,
        bookEditorState: BookEditorState.initial(book.copyWith())));
  }

  void toggleChapterOutline(WritingUIEvent event, WritingUIEmiter emit) {
    emit(state.copyWith(chapterOutlineShown: !state.chapterOutlineShown));
  }

  void toggleFeedback(WritingUIEvent event, WritingUIEmiter emit) {
    emit(state.copyWith(
        feedbackUIshown: !state.feedbackUIshown, roadUnblockerShown: false, continuityCheckerShown: false));
  }

  void toggleRoadUnblocker(ToggleRoadUnblockerEvent event, Emitter<WritingUIState> emit) {
    emit(state.copyWith(
        roadUnblockerShown: !state.roadUnblockerShown, feedbackUIshown: false, continuityCheckerShown: false));
  }

  void toggleContinuityChecker(ToggleContinuityCheckerEvent event, WritingUIEmiter emit) {
    emit(state.copyWith(
        continuityCheckerShown: !state.continuityCheckerShown, feedbackUIshown: false, roadUnblockerShown: false));
  }

  Future<void> highlight(HighlightEvent event, WritingUIEmiter emit) async {
    final scrollController = state.textScrollController;

    if (scrollController.hasClients) {
      final chapterText = event.chapterText;
      TextPainter painter = TextPainter(
        text: TextSpan(text: chapterText, style: event.textStyle),
        textDirection: TextDirection.ltr,
      );

      // Calculate the offset of the feedback
      painter.layout(maxWidth: pageWidth);
      final feedbackOffset = painter.getOffsetForCaret(TextPosition(offset: event.selection.offset), Rect.zero);

      await scrollController.animateTo(feedbackOffset.dy, duration: Duration(milliseconds: 500), curve: Curves.easeIn);

      // Create a temporary highlight effect on the feedback
      final List<TextBox> boxes = painter.getBoxesForSelection(
          TextSelection(baseOffset: event.selection.offset, extentOffset: event.selection.offsetEnd));

      // Map all the boxes to rects and update the state
      final rects = boxes.map((e) => e.toRect()).toList();
      emit(state.copyWith(rectsToHighlight: rects));

      // Remove the highlight after a second
      timer?.cancel(); // Cancel the existing timer if there is one
      await Timer(Duration(milliseconds: 1000), () {
        add(RemoveHighlightEvent());
      });
    }
  }

  void removeHighlight(RemoveHighlightEvent event, WritingUIEmiter emit) {
    // if there is a timer, cancel it
    timer?.cancel();
    emit(state.copyWith(rectsToHighlight: null));
  }

  void deleteBook(DeleteBookEvent event, WritingUIEmiter emit) {
    repository.deleteBook(state.bookId);
  }

  void updateBook(UpdateBookEvent event, WritingUIEmiter emit) async {
    final result = await repository.updateBook(bookId: state.bookId, book: state.bookEditorState!.book);

    if (result != null) {
      emit(state.copyWith(book: result));
      add(ClearUpdateBookEvent());
    }
  }

  void updateBookLanguage(UpdateBookLanguageEvent event, WritingUIEmiter emit) {
    emit(state.copyWith(
        bookEditorState:
            state.bookEditorState!.copyWith(book: state.bookEditorState!.book.copyWith(language: event.language))));
  }

  void updateBookTitle(UpdateBookTitleEvent event, WritingUIEmiter emit) {
    emit(state.copyWith(
        bookEditorState:
            state.bookEditorState!.copyWith(book: state.bookEditorState!.book.copyWith(title: event.title))));
  }

  void updateBookDescription(UpdateBookSynopsisEvent event, WritingUIEmiter emit) {
    emit(state.copyWith(
        bookEditorState:
            state.bookEditorState!.copyWith(book: state.bookEditorState!.book.copyWith(synopsis: event.synopsis))));
  }

  void updateBookTargetAudience(UpdateBookTargetAudienceEvent event, WritingUIEmiter emit) {
    emit(state.copyWith(
        bookEditorState: state.bookEditorState!
            .copyWith(book: state.bookEditorState!.book.copyWith(targetAudience: event.targetAudience))));
  }

  void updateBookCopyright(UpdateBookCopyrightEvent event, WritingUIEmiter emit) {
    emit(state.copyWith(
        bookEditorState:
            state.bookEditorState!.copyWith(book: state.bookEditorState!.book.copyWith(copyright: event.copyright))));
  }

  Future<void> selectUpdatedBookCover(SelectUpdatedBookCoverEvent event, WritingUIEmiter emit) async {
    FilePicker platformFilePicker = FilePicker.platform;
    FilePickerResult? result = await platformFilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    // convert the image to base 64
    if (result != null) {
      // get file from bytes since web doesn't support path

      emit(state.copyWith(
          bookEditorState: state.bookEditorState!
              .copyWith(imageTitle: result.files.single.name, imageBytes: result.files.single.bytes)));
    }
  }

  clearUpdateBook(ClearUpdateBookEvent event, WritingUIEmiter emit) {
    emit(state.copyWith(bookEditorState: BookEditorState.initial(state.book!)));
  }
}
