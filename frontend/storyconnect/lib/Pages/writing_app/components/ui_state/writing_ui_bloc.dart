import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/text_annotation/text_selection.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/_state/writing_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/feedback/state/feedback_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/page_sliver.dart';
import 'package:storyconnect/Repositories/writing_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'writing_ui_bloc.freezed.dart';
part 'writing_ui_state.dart';
part 'writing_ui_event.dart';

class WritingLoadEvent extends WritingUIEvent {
  final int bookId;
  final WritingBloc writingBloc;
  final FeedbackBloc feedbackBloc;
  WritingLoadEvent({
    required this.bookId,
    required this.writingBloc,
    required this.feedbackBloc,
  });
}

typedef WritingUIEmiter = Emitter<WritingUIState>;

class WritingUIBloc extends Bloc<WritingUIEvent, WritingUIState> {
  static Timer?
      timer; // Static variable to maintain state between calls to highlight
  WritingRepository repository = WritingRepository();
  WritingUIBloc({required this.repository}) : super(WritingUIState.initial()) {
    on<UpdateAllEvent>((event, emit) => updateUI(event, emit));
    on<WritingLoadEvent>((event, emit) => loadEvent(event, emit));
    on<ToggleChapterOutlineEvent>(
        (event, emit) => toggleChapterOutline(event, emit));
    on<ToggleFeedbackUIEvent>((event, emit) => toggleFeedback(event, emit));
    on<ToggleRoadUnblockerEvent>(
        (event, emit) => toggleRoadUnblocker(event, emit));
    on<ToggleContinuityCheckerEvent>(
        (event, emit) => toggleContinuityChecker(event, emit));

    on<HighlightEvent>((event, emit) => highlight(event, emit));

    on<RemoveHighlightEvent>((event, emit) => removeHighlight(event, emit));
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
    emit(state.copyWith(
        loadingStruct: LoadingStruct.loading(true), bookId: event.bookId));

    event.writingBloc.add(FeedbackLoadEvent(
      event.feedbackBloc,
    ));

    final title = await _getBookTitle(event.bookId);

    emit(state.copyWith(
      loadingStruct: LoadingStruct.loading(false),
      title: title,
    ));
  }

  void toggleChapterOutline(WritingUIEvent event, WritingUIEmiter emit) {
    emit(state.copyWith(chapterOutlineShown: !state.chapterOutlineShown));
  }

  void toggleFeedback(WritingUIEvent event, WritingUIEmiter emit) {
    emit(state.copyWith(
        feedbackUIshown: !state.feedbackUIshown,
        roadUnblockerShown: false,
        continuityCheckerShown: false));
  }

  void toggleRoadUnblocker(
      ToggleRoadUnblockerEvent event, Emitter<WritingUIState> emit) {
    emit(state.copyWith(
        roadUnblockerShown: !state.roadUnblockerShown,
        feedbackUIshown: false,
        continuityCheckerShown: false));
  }

  void toggleContinuityChecker(
      ToggleContinuityCheckerEvent event, Emitter<WritingUIState> emit) {
    emit(state.copyWith(
        continuityCheckerShown: !state.continuityCheckerShown,
        feedbackUIshown: false,
        roadUnblockerShown: false));
  }

  Future<void> highlight(
      HighlightEvent event, Emitter<WritingUIState> emit) async {
    final scrollController = state.textScrollController;

    if (scrollController.hasClients) {
      final chapterText = event.chapterText;
      TextPainter painter = TextPainter(
        text: TextSpan(text: chapterText, style: event.textStyle),
        textDirection: TextDirection.ltr,
      );

      // Calculate the offset of the feedback
      painter.layout(maxWidth: RenderPageSliver.pageWidth);
      final feedbackOffset = painter.getOffsetForCaret(
          TextPosition(offset: event.selection.offset), Rect.zero);

      await scrollController.animateTo(feedbackOffset.dy,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);

      // Create a temporary highlight effect on the feedback
      final List<TextBox> boxes = painter.getBoxesForSelection(TextSelection(
          baseOffset: event.selection.offset,
          extentOffset: event.selection.offsetEnd));

      // Map all the boxes to rects and update the state
      emit(state.copyWith(
          rectsToHighlight: boxes.map((e) => e.toRect()).toList()));

      // Remove the highlight after a second
      timer?.cancel(); // Cancel the existing timer if there is one
      await Timer(Duration(milliseconds: 1000), () {
        add(RemoveHighlightEvent());
      });
    }
  }

  void removeHighlight(
      RemoveHighlightEvent event, Emitter<WritingUIState> emit) {
    // if there is a timer, cancel it
    timer?.cancel();
    emit(state.copyWith(rectsToHighlight: null));
  }
}
