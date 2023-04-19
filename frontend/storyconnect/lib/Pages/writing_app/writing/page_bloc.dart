import 'package:flutter/painting.dart';
import 'package:bloc/bloc.dart';
import 'package:storyconnect/Pages/writing_app/writing/paging_logic.dart';

abstract class PageEvent {
  int callerIndex;
  PageEvent({required this.callerIndex});
}

class AddPage extends PageEvent {
  final String text;
  AddPage({required this.text, required int callerIndex})
      : super(callerIndex: callerIndex);
}

class RemovePage extends PageEvent {
  RemovePage({required super.callerIndex});
}

class UpdatePage extends PageEvent {
  final String text;
  UpdatePage({required this.text, required super.callerIndex});
}

class RebuildPages extends PageEvent {
  String text;
  RebuildPages({
    required this.text,
  }) : super(callerIndex: 0);
}

class InitPage extends PageEvent {
  InitPage({required super.callerIndex});
}

class ResetNavigation extends PageEvent {
  ResetNavigation({required super.callerIndex});
}

class PageBlocStruct {
  final Map<int, String> pages;
  final int? navigateToIndex;
  PageBlocStruct({required this.pages, this.navigateToIndex});
}

typedef PageEmitter = Emitter<PageBlocStruct>;

class PageBloc extends Bloc<PageEvent, PageBlocStruct> {
  final PagingLogic pagingLogic = PagingLogic();
  final TextStyle style = TextStyle(fontSize: 20);
  PageBloc() : super(PageBlocStruct(pages: {0: ""})) {
    on<AddPage>((event, emit) => _addPage(event, emit));
    on<RemovePage>((event, emit) => _removePage(event, emit));
    on<UpdatePage>((event, emit) => _updatePage(event, emit));
    on<RebuildPages>((event, emit) => _rebuildPages(event, emit));
    on<InitPage>((event, emit) => _initPage(event, emit));
  }

  void _addPage(AddPage event, PageEmitter emit) {
    Map<int, String> pages = Map.from(state.pages);
    int pageToJumpTo = _addPageHelper(pages, event.text, event.callerIndex + 1);
    emit(PageBlocStruct(pages: pages, navigateToIndex: pageToJumpTo));
  }

  int _addPageHelper(Map<int, String> pages, String text, int pageIndex) {
    final results = pagingLogic.shouldTriggerOverflow(text, style);
    if (results.didOverflow) {
      pages[pageIndex] = results.textToKeep;
      return _addPageHelper(pages, results.overflowText, pageIndex + 1);
    } else {
      pages[pageIndex] = text;
      return pageIndex;
    }
  }

  void _removePage(RemovePage event, PageEmitter emit) {
    if (event.callerIndex != 0) {
      Map<int, String> pages = Map.from(state.pages);

      pages.remove(event.callerIndex);
      final result =
          PageBlocStruct(pages: pages, navigateToIndex: event.callerIndex - 1);
      emit(result);
    }
  }

  void _updatePage(UpdatePage event, PageEmitter emit) {
    Map<int, String> pages = Map.from(state.pages);
    pages[event.callerIndex] = event.text;
    PageBlocStruct result = PageBlocStruct(
      pages: pages,
    );
    emit(result);
  }

  void _rebuildPages(RebuildPages event, PageEmitter emit) {
    emit(PageBlocStruct(pages: {}));
    _addPage(AddPage(text: event.text, callerIndex: -1), emit);
  }

  _initPage(InitPage event, Emitter<PageBlocStruct> emit) {
    emit(PageBlocStruct(
        pages: state.pages, navigateToIndex: state.navigateToIndex));
  }
}
