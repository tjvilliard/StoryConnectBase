import 'package:flutter/painting.dart';
import 'package:bloc/bloc.dart';

class WritingAppBloc {
  static OverFlowStruct shouldTriggerOverflow(String text, TextStyle style) {
    final TextPainter _textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    StringBuffer moveToNextPage = StringBuffer();
    bool didOverflow = false;

    _textPainter.text = TextSpan(text: text, style: style);
    _textPainter.layout(maxWidth: 800);

    Size size = _textPainter.size;
    while (size.height > 800) {
      didOverflow = true;
      // move the last line to the next page
      int start = text.lastIndexOf(' ');
      final int end = text.length;

      if (start == -1) {
        start = end - 100;
      }

      moveToNextPage.write(text.substring(start, end));
      text = text.replaceRange(start, end, "");
      _textPainter.text = TextSpan(
        text: text,
        style: style,
      );
      _textPainter.layout(maxWidth: 800);
      size = _textPainter.size;
    }

    return OverFlowStruct(
        didOverflow: didOverflow,
        textToKeep: text,
        overflowText: moveToNextPage.toString());
  }
}

class OverFlowStruct {
  final bool didOverflow;
  final String textToKeep;
  final String overflowText;
  OverFlowStruct(
      {required this.didOverflow,
      required this.textToKeep,
      required this.overflowText});
}

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

typedef PageEmitter = Emitter<Map<int, String>>;

class PageBloc extends Bloc<PageEvent, Map<int, String>> {
  final TextStyle style = TextStyle(fontSize: 20);
  PageBloc() : super({0: ""}) {
    on<AddPage>((event, emit) => _addPage(event, emit));
    on<RemovePage>((event, emit) => _removePage(event, emit));
    on<UpdatePage>((event, emit) => _updatePage(event, emit));
  }

  void _addPage(
    AddPage event,
    PageEmitter emit,
  ) {
    Map<int, String> pages = Map.from(state);
    String textToUse = event.text;

    final results = WritingAppBloc.shouldTriggerOverflow(textToUse, style);
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
    state.remove(event.callerIndex);
    emit(state);
  }

  void _updatePage(UpdatePage event, PageEmitter emit) {
    Map<int, String> pages = Map.from(state);
    pages[event.callerIndex] = event.text;
    emit(pages);
  }
}
