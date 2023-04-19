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
  RemovePage({required int callerIndex}) : super(callerIndex: callerIndex);
}

class UpdatePage extends PageEvent {
  final String text;
  UpdatePage({required this.text, required int callerIndex})
      : super(callerIndex: callerIndex);
}

class RebuildPages extends PageEvent {
  String text;
  RebuildPages({required this.text}) : super(callerIndex: 0);
}

typedef PageEmitter = Emitter<Map<int, String>>;

class PageBloc extends Bloc<PageEvent, Map<int, String>> {
  final PagingLogic pagingLogic = PagingLogic();
  final TextStyle style = TextStyle(fontSize: 20);
  PageBloc() : super({0: ""}) {
    on<AddPage>((event, emit) => _addPage(event, emit));
    on<RemovePage>((event, emit) => _removePage(event, emit));
    on<UpdatePage>((event, emit) => _updatePage(event, emit));
    on<RebuildPages>((event, emit) => _rebuildPages(event, emit));
  }

  void _addPage(AddPage event, PageEmitter emit) {
    Map<int, String> pages = Map.from(state);
    _addPageHelper(pages, event.text, event.callerIndex + 1);
    emit(pages);
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
      state.remove(event.callerIndex);
      emit(state);
    }
  }

  void _updatePage(UpdatePage event, PageEmitter emit) {
    Map<int, String> pages = Map.from(state);
    pages[event.callerIndex] = event.text;
    emit(pages);
  }

  void _rebuildPages(RebuildPages event, PageEmitter emit) {
    emit({});
    _addPage(AddPage(text: event.text, callerIndex: -1), emit);
  }
}
