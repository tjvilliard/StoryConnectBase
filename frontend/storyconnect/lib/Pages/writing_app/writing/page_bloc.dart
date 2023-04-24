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
  AddPage({required this.text, required int callerIndex})
      : super(callerIndex: callerIndex);
}

class RemovePage extends PageEvent {
  RemovePage({required int callerIndex}) : super(callerIndex: callerIndex);
}

class UpdatePage extends PageEvent {
  final String text;
  final ChapterBloc chapterBloc;
  UpdatePage(
      {required this.text, required int callerIndex, required this.chapterBloc})
      : super(callerIndex: callerIndex);
}

class RebuildPages extends PageEvent {
  String text;
  RebuildPages({required this.text}) : super(callerIndex: 0);
}

class PageBlocStruct {
  final LoadingStruct loadingStruct;
  final Map<int, String> pages;

  PageBlocStruct({required this.loadingStruct, required this.pages});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PageBlocStruct &&
        other.loadingStruct == loadingStruct &&
        _mapsAreEqual(other.pages, pages);
  }

  @override
  int get hashCode => loadingStruct.hashCode ^ _mapHashCode(pages);

  bool _mapsAreEqual(Map<int, String> a, Map<int, String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  int _mapHashCode(Map<int, String> map) {
    int hash = 0;
    for (int i = 0; i < map.length; i++) {
      hash ^= map[i].hashCode;
    }
    return hash;
  }
}

typedef PageEmitter = Emitter<PageBlocStruct>;

class PageBloc extends Bloc<PageEvent, PageBlocStruct> {
  final PagesProviderRepository repository;
  final PagingLogic pagingLogic = PagingLogic();
  final TextStyle style = TextStyle(fontSize: 20);
  PageBloc(this.repository)
      : super(PageBlocStruct(
            loadingStruct: LoadingStruct.loading(true), pages: {0: ''})) {
    on<AddPage>((event, emit) => _addPage(event, emit));
    on<RemovePage>((event, emit) => _removePage(event, emit));
    on<UpdatePage>((event, emit) => _updatePage(event, emit));
    on<RebuildPages>((event, emit) => _rebuildPages(event, emit));
  }

  void _addPage(AddPage event, PageEmitter emit) {
    Map<int, String> pages = Map.from(state.pages);
    _addPageHelper(pages, event.text, event.callerIndex + 1);
    emit(PageBlocStruct(
        loadingStruct: LoadingStruct.loading(false), pages: pages));
  }

  void _addPageHelper(Map<int, String> pages, String text, int pageIndex) {
    final results = pagingLogic.shouldTriggerOverflow(text, style);
    if (results.didOverflow) {
      pages[pageIndex] = results.textToKeep;
      _addPageHelper(pages, results.overflowText, pageIndex + 1);
    } else {
      pages[pageIndex] = text;
    }
  }

  void _removePage(RemovePage event, PageEmitter emit) {
    if (event.callerIndex != 0) {
      final Map<int, String> pages = Map.from(state.pages);
      pages.remove(event.callerIndex);
      emit(PageBlocStruct(
          loadingStruct: LoadingStruct.loading(false), pages: pages));
    }
  }

  void _updatePage(UpdatePage event, PageEmitter emit) {
    Map<int, String> pages = Map.from(state.pages);
    pages[event.callerIndex] = event.text;
    emit(PageBlocStruct(
        loadingStruct: LoadingStruct.loading(false), pages: pages));
    event.chapterBloc.add(UpdateChapter(text: pages.values.join()));
  }

  void _rebuildPages(RebuildPages event, PageEmitter emit) {
    emit(PageBlocStruct(loadingStruct: LoadingStruct.loading(true), pages: {}));
    _addPage(AddPage(text: event.text, callerIndex: -1), emit);
  }
}
