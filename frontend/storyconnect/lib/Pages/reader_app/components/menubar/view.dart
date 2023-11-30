import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/menubar/menu_buttons.dart';
import 'package:storyconnect/Pages/reader_app/components/menubar/library_button.dart';
import 'package:storyconnect/Pages/reader_app/components/reading/state/reading_bloc.dart';

class ReadingMenuBar extends StatefulWidget {
  static const double height = 40;
  final int bookId;

  const ReadingMenuBar({required this.bookId, super.key});

  @override
  ReadingMenuBarState createState() => ReadingMenuBarState();
}

class ReadingMenuBarState extends State<ReadingMenuBar> {
  int get bookId => widget.bookId;

  static ShapeBorder widgetRadius =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0));

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadingBloc, ReadingState>(
        builder: (context, readingState) {
      return Card(
          shape: widgetRadius,
          margin: const EdgeInsets.all(8),
          child: Container(
              padding: const EdgeInsets.all(4),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: OverflowBar(
                                clipBehavior: Clip.hardEdge,
                                overflowDirection: VerticalDirection.up,
                                textDirection: TextDirection.ltr,
                                overflowAlignment: OverflowBarAlignment.start,
                                children: [
                                  PreviousChapterButton(),
                                  NextChapterButton(),
                                  ChapterNavigationBarButton(),
                                ]))),
                    Expanded(
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: OverflowBar(
                                clipBehavior: Clip.hardEdge,
                                overflowDirection: VerticalDirection.up,
                                textDirection: TextDirection.ltr,
                                overflowAlignment: OverflowBarAlignment.start,
                                children: [
                                  const AuthorPageButton(),
                                  LibraryMenuButton(bookId: bookId),
                                  const ToggleChapterFeedback(),
                                ])))
                  ])));
    });
  }
}
