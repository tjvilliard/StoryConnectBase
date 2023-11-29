import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/menubar/buttons.dart';
import 'package:storyconnect/Pages/reader_app/components/menubar/library_button.dart';
import 'package:storyconnect/Pages/reader_app/components/reading/state/reading_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/ui_state/reading_ui_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/state/reading_hub_bloc.dart';

class ReadingMenuBar extends StatefulWidget {
  static const double height = 40;
  final int bookId;

  const ReadingMenuBar({required this.bookId, super.key});

  @override
  ReadingMenuBarState createState() => ReadingMenuBarState();
}

class ReadingMenuBarState extends State<ReadingMenuBar> {
  late bool inLibrary;

  int get bookId => widget.bookId;

  static ShapeBorder widgetRadius =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadingUIBloc, ReadingUIState>(
        builder: (context, uiState) {
      return BlocBuilder<ReadingBloc, ReadingState>(
          builder: (context, chapterState) {
        return BlocBuilder<ReadingHubBloc, ReadingHubStruct>(
            builder: (context, libState) {
          return Card(
              shape: widgetRadius,
              margin: const EdgeInsets.all(8),
              child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: OverflowBar(
                                    clipBehavior: Clip.hardEdge,
                                    overflowDirection: VerticalDirection.up,
                                    textDirection: TextDirection.ltr,
                                    overflowAlignment:
                                        OverflowBarAlignment.start,
                                    children: [
                                      NavigateBackwardButton(
                                          disableCondition:
                                              chapterState.currentIndex == 0),
                                      NavigateForwardButton(
                                          disableCondition: chapterState
                                                  .currentIndex ==
                                              chapterState.chapters.length - 1),
                                      const ChapterNavigationBarButton(
                                          disableCondition: false),
                                    ]))),
                        Expanded(
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: OverflowBar(
                                    clipBehavior: Clip.hardEdge,
                                    overflowDirection: VerticalDirection.up,
                                    textDirection: TextDirection.ltr,
                                    overflowAlignment:
                                        OverflowBarAlignment.start,
                                    children: [
                                      const AuthorPageButton(
                                          disableCondition: true),
                                      LibraryMenuButton(bookId: bookId),
                                      const ChapterFeedbackButton(
                                          disableCondition: false),
                                    ])))
                      ])));
        });
      });
    });
  }
}
