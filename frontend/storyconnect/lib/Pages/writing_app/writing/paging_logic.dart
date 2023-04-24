import 'package:flutter/painting.dart';
import 'package:storyconnect/Pages/writing_app/writing/page_bloc.dart';

class OverFlowStruct {
  final bool didOverflow;
  final String textToKeep;
  final String overflowText;
  OverFlowStruct(
      {required this.didOverflow,
      required this.textToKeep,
      required this.overflowText});
}

class PagingLogic {
  OverFlowStruct shouldTriggerOverflow(String text, TextStyle style) {
    TextPainter overflowPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    StringBuffer overflowBuffer = StringBuffer();
    bool didOverflow = false;
    overflowPainter.text = TextSpan(text: text, style: style);
    overflowPainter.layout(maxWidth: PageBloc.pageWidth);

    while (overflowPainter.height > (PageBloc.pageHeight - 100)) {
      didOverflow = true;
      // move the last line to the next page
      int start = text.lastIndexOf(' ');
      final int end = text.length;

      if (start == -1) {
        start = end - 100;
      }

      overflowBuffer.write(text.substring(start, end));
      text = text.replaceRange(start, end, "");
      overflowPainter.text = TextSpan(
        text: text,
        style: style,
      );
      overflowPainter.layout(maxWidth: PageBloc.pageWidth);
    }

    return OverFlowStruct(
        didOverflow: didOverflow,
        textToKeep: text,
        overflowText: overflowBuffer.toString());
  }

  bool shouldTriggerUnderFlow(String text, TextStyle style) {
    final TextPainter _textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    _textPainter.text = TextSpan(text: text, style: style);
    _textPainter.layout(maxWidth: 800);

    Size size = _textPainter.size;
    if (size.height < 700) {
      return true;
    }
    return false;
  }
}
