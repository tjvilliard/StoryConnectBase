import 'package:flutter/painting.dart';
import 'package:bloc/bloc.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Pages/writing_app/chapter/chapter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/pages_repository.dart';
import 'package:storyconnect/Pages/writing_app/writing/paging_logic.dart';

abstract class PageEvent {
  int callerIndex;
  PageEvent({required this.callerIndex});
}

class AddPage extends PageEvent {
  final String text;
  final bool shouldJump;
  AddPage({
    required this.text,
    required this.shouldJump,
    required int callerIndex,
  }) : super(callerIndex: callerIndex);
}

class RemovePage extends PageEvent {
  RemovePage({required super.callerIndex});
}

class UpdatePage extends PageEvent {
  final String text;
  final bool shouldJump;
  final ChapterBloc chapterBloc;

  UpdatePage(
      {required this.text,
      required super.callerIndex,
      required this.shouldJump,
      required this.chapterBloc});
}

class RebuildPages extends PageEvent {
  String text;
  RebuildPages({
    required this.text,
  }) : super(callerIndex: 0);
}

class ResetNavigation extends PageEvent {
  ResetNavigation({required super.callerIndex});
}

class PageBlocStruct {
  final Map<int, String> pages;
  final int? navigateToIndex;
  final Map<int, bool> pagesCreated;
  final bool cursorStart;
  final LoadingStruct loadingStruct;

  PageBlocStruct(
      {required this.pages,
      this.navigateToIndex,
      required this.pagesCreated,
      this.cursorStart = true,
      required this.loadingStruct});
}

typedef PageEmitter = Emitter<PageBlocStruct>;

class PageBloc extends Bloc<PageEvent, PageBlocStruct> {
  static double pageHeight = 1100.0;
  static double pageWidth = 800.0;
  final PagesProviderRepository repository;
  final PagingLogic pagingLogic = PagingLogic();
  final TextStyle style = TextStyle(fontSize: 20);
  PageBloc(this.repository)
      : super(PageBlocStruct(
            pagesCreated: {},
            loadingStruct: LoadingStruct.loading(true),
            pages: {0: ''})) {
    on<AddPage>((event, emit) => _addPage(event, emit));
    on<RemovePage>((event, emit) => _removePage(event, emit));
    on<UpdatePage>((event, emit) => _updatePage(event, emit));
    on<RebuildPages>((event, emit) => _rebuildPages(event, emit));
  }

  void _addPage(AddPage event, PageEmitter emit) {
    Map<int, String> pages = Map.from(state.pages);
    Map<int, bool> pagesCreated = Map.from(state.pagesCreated);
    int recursivePageInt =
        _addPageHelper(pages, pagesCreated, event.text, event.callerIndex + 1);

    for (var pageIndex in pagesCreated.keys) {
      if ((pagesCreated[pageIndex] == true &&
              pagesCreated[pageIndex + 1] == true) ||
          event.shouldJump == false) {
        pagesCreated[pageIndex] = false;
      }
    }
    int? pageToJumpTo;
    if (event.shouldJump) {
      pageToJumpTo = recursivePageInt;
    }
    emit(PageBlocStruct(
        pages: pages,
        navigateToIndex: pageToJumpTo,
        pagesCreated: pagesCreated,
        cursorStart: false,
        loadingStruct: LoadingStruct.loading(false)));
  }

  int _addPageHelper(Map<int, String> pages, Map<int, bool> pagesCreated,
      String text, int pageIndex) {
    final existingPageContent = pages[pageIndex] ?? "";

    final results =
        pagingLogic.shouldTriggerOverflow("$text $existingPageContent", style);
    pagesCreated[pageIndex] = true;
    if (results.didOverflow) {
      pages[pageIndex] = results.textToKeep;
      return _addPageHelper(
          pages, pagesCreated, results.overflowText, pageIndex + 1);
    } else {
      // Append the new text to the existing content instead of overwriting it
      pages[pageIndex] = "$text $existingPageContent".trim();
      return pageIndex;
    }
  }

  void _removePage(RemovePage event, PageEmitter emit) {
    if (event.callerIndex != 0) {
      Map<int, String> pages = Map.from(state.pages);
      Map<int, bool> pagesCreated = Map.from(state.pagesCreated);
      pages.remove(event.callerIndex);
      pagesCreated.remove(event.callerIndex);

      final result = PageBlocStruct(
          pages: pages,
          navigateToIndex: event.callerIndex - 1,
          pagesCreated: pagesCreated,
          loadingStruct: LoadingStruct.loading(false),
          cursorStart: false);
      emit(result);
    }
  }

  void _updatePage(UpdatePage event, PageEmitter emit) {
    Map<int, String> pages = Map.from(state.pages);
    pages[event.callerIndex] = event.text;
    PageBlocStruct result = PageBlocStruct(
        pages: pages,
        pagesCreated: state.pagesCreated,
        navigateToIndex: null,
        loadingStruct: LoadingStruct.loading(false));
    emit(result);
  }

  void _rebuildPages(RebuildPages event, PageEmitter emit) {
    emit(PageBlocStruct(
        pages: {},
        pagesCreated: {0: true},
        loadingStruct: LoadingStruct.message("Building Book")));
    _addPage(
        AddPage(text: event.text, callerIndex: -1, shouldJump: true), emit);
  }
}
