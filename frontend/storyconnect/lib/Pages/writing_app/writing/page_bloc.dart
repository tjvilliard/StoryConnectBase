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

  void _addPage(
    AddPage event,
    PageEmitter emit,
  ) {
    Map<int, String> pages = Map.from(state);
    String textToUse = event.text;

    final results = pagingLogic.shouldTriggerOverflow(textToUse, style);
    if (results.didOverflow) {
      textToUse = results.textToKeep;
      _addPage(
          AddPage(
              text: results.overflowText, callerIndex: event.callerIndex + 2),
          emit);
    }
    pages[event.callerIndex + 1] = textToUse;
    emit(pages);
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
    Map<int, String> pages = Map.from(state);
    pages.clear();
    emit(pages);
    add(AddPage(text: event.text, callerIndex: -1));
  }
}
