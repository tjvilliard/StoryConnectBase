import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/state/feedback_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/reading_pages_repository.dart';
import 'package:visual_editor/doc-tree/models/vertical-spacing.model.dart';
import 'package:visual_editor/document/models/delta-doc.model.dart';
import 'package:visual_editor/editor/models/editor-cfg.model.dart';
import 'package:visual_editor/styles/models/cfg/editor-styles.model.dart';
import 'package:visual_editor/styles/models/doc-tree/text-block-style.model.dart';

part 'reading_events.dart';
part 'reading_state.dart';
part 'reading_bloc.freezed.dart';

typedef ReadingEmitter = Emitter<ReadingState>;

class ReadingBloc extends Bloc<ReadingEvent, ReadingState> {
  late final BookProviderRepository _repo;
  ReadingBloc(BookProviderRepository repository)
      : super(ReadingState.initial()) {
    this._repo = repository;
  }

  void loadReadingEvent(LoadReadingEvent event, ReadingEmitter emit) async {
    emit(state.copyWith(loadingStruct: LoadingStruct.message("Loading Book")));
    final unParsedChapters = await _repo.getChapters();
    final _ParsedChapterResult result = _parseChapters(unParsedChapters);
    print("we should only be calling this once");

    final doc = convertToDeltaDoc(result.chapters[0]!);

    emit(state.copyWith(
        chapters: result.chapters,
        chapterNumToID: result.chapterNumToID,
        loadingStruct: LoadingStruct.loading(false)));

    final chapterId = state.chapterNumToID[state.currentIndex]!;
    //event.feedbackBloc.add(LoadChapterFeedback(chapterId));
  }

  // helper function to load chapters into expected format
  _ParsedChapterResult _parseChapters(List<Chapter> chapters) {
    final Map<int, int> chapterNumToID = {};
    Map<int, String> parsedChapters = {};
    for (Chapter chapter in chapters) {
      chapterNumToID[chapter.number] = chapter.id;
      parsedChapters[chapter.number] = chapter.chapterContent;
    }
    return _ParsedChapterResult(
        chapters: parsedChapters, chapterNumToID: chapterNumToID);
  }

  void switchChapter(SwitchChapterEvent event, ReadingEmitter emit) async {
    final doc = convertToDeltaDoc(state.chapters[event.chapterToSwitchTo]!);

    emit(state.copyWith(
      currentIndex: event.chapterToSwitchTo,
    ));
  }

  DeltaDocM convertToDeltaDoc(String json) {
    DeltaDocM doc;
    try {
      doc = DeltaDocM.fromJson(jsonDecode(json));
    } catch (e) {
      print("Unable to convert to Delta doc, returning as blank chapter: $e");
      doc = DeltaDocM();
    }
    return doc;
  }
}
