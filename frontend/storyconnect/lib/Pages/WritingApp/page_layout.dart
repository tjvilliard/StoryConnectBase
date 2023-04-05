import 'package:flutter/material.dart';

class PageStructure {
  final TextPainter _textPainter = TextPainter(
    textDirection: TextDirection.ltr,
  );

  final TextStyle style;
  PageStructure({required this.style});

  Map<int, String> layout({required Map<int, String> pages}) {
    StringBuffer moveToNextPage = StringBuffer();
    Map<int, String> pageMap = Map();

    int rollingLength = pages.length;

    for (var i = 0; i < rollingLength; i++) {
      if (moveToNextPage.isNotEmpty) {
        pages[i] = moveToNextPage.toString() + pages[i]!;
        moveToNextPage.clear();
      }
      _textPainter.text = TextSpan(
        text: pages[i],
        style: style,
      );
      _textPainter.layout(maxWidth: 800);
      Size size = _textPainter.size;
      while (size.height > 800) {
        // move the last line to the next page
        int start = pages[i]!.lastIndexOf(' ');
        final int end = pages[i]!.length;

        if (start == -1) {
          start = end - 100;
        }

        moveToNextPage.write(pages[i]!.substring(start, end));
        pages[i] = pages[i]!.replaceRange(start, end, "");
        _textPainter.text = TextSpan(
          text: pages[i],
          style: style,
        );
        _textPainter.layout(maxWidth: 800);
        size = _textPainter.size;
      }
      pageMap[i] = pages[i]!;
    }
    if (moveToNextPage.isNotEmpty) {
      pageMap[pageMap.length] = moveToNextPage.toString();
    }

    return pageMap;
  }
}

class WritingPage {
  String text;
  WritingPage({required this.text});
}
