import 'package:flutter/painting.dart';

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
