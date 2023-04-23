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
  static TextPainter _textPainter = TextPainter(
    textDirection: TextDirection.ltr,
  );
  static StringBuffer moveToNextPage = StringBuffer();
  static int? _maxCharsPerPage;

  OverFlowStruct shouldTriggerOverflow(String text, TextStyle style) {
    moveToNextPage.clear();
    bool didOverflow = false;

    if (_maxCharsPerPage == null) {
      _calculateMaxCharsPerPage(style);
    }

    while (text.length > _maxCharsPerPage!) {
      didOverflow = true;
      int start = text.lastIndexOf(' ', _maxCharsPerPage!);
      if (start == -1) {
        start = _maxCharsPerPage! - 100;
      }

      moveToNextPage.write(text.substring(start));
      text = text.substring(0, start);
    }

    return OverFlowStruct(
        didOverflow: didOverflow,
        textToKeep: text,
        overflowText: moveToNextPage.toString());
  }

  void _calculateMaxCharsPerPage(TextStyle style) {
    StringBuffer testBuffer = StringBuffer();
    int max = 0;

    _textPainter.text = TextSpan(text: "A", style: style);
    _textPainter.layout(maxWidth: PageBloc.pageWidth);
    while (_textPainter.size.height < PageBloc.pageHeight) {
      testBuffer.write("AAAA");
      max += 4;
      _textPainter.text = TextSpan(text: testBuffer.toString(), style: style);
      _textPainter.layout(maxWidth: PageBloc.pageWidth);
    }

    _maxCharsPerPage = max;
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
