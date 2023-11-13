import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/reader_app/components/chapter/state/chapter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/menubar/library_button.dart';
import 'package:storyconnect/Pages/reader_app/components/menubar/reading_menu_button.dart';
import 'package:storyconnect/Pages/reader_app/components/ui_state/reading_ui_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/library/state/library_bloc.dart';

class ReadingMenuBar extends StatefulWidget {
  static const double height = 40;
  final int bookId;

  ReadingMenuBar({required this.bookId, super.key});

  @override
  State<StatefulWidget> createState() => _readingMenuBarState(bookId: bookId);
}

class _readingMenuBarState extends State<ReadingMenuBar> {
  final int bookId;
  late bool inLibrary;

  _readingMenuBarState({required this.bookId});

  static ShapeBorder widget_radius =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadingUIBloc, ReadingUIState>(
        builder: (context, uiState) {
      return BlocBuilder<ChapterBloc, ChapterBlocStruct>(
          builder: (context, chapterState) {
        return BlocBuilder<LibraryBloc, LibraryStruct>(
          builder: (context, libState) {
            return Card(
                shape: widget_radius,
                margin: EdgeInsets.all(8),
                child: Padding(
                    padding: EdgeInsets.all(4),
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
                                        // Previous chapter button
                                        ReadingIconButton(
                                          icon: Icon(Icons.arrow_left),
                                          onPressed: chapterState
                                                      .currentChapterIndex ==
                                                  0
                                              ? null
                                              : () {
                                                  context
                                                      .read<ChapterBloc>()
                                                      .add(DecrementChapterEvent(
                                                          currentChapter:
                                                              chapterState
                                                                  .currentChapterIndex));
                                                },
                                        ),

                                        // Navigate Chapter Forward
                                        ReadingIconButton(
                                          icon:
                                              Icon(FontAwesomeIcons.arrowRight),
                                          onPressed: chapterState
                                                      .currentChapterIndex ==
                                                  chapterState.chapters.length -
                                                      1
                                              ? null
                                              : () {
                                                  context
                                                      .read<ChapterBloc>()
                                                      .add(IncrementChapterEvent(
                                                          currentChapter:
                                                              chapterState
                                                                  .currentChapterIndex));
                                                },
                                        ),

                                        // Bring Up the Chapter Navigation Bar
                                        ReadingIconButton(
                                            icon: Icon(FontAwesomeIcons.list),
                                            label: "Chapter ${chapterState.currentChapterIndex + 1}" +
                                                "/${chapterState.chapters.length} ",
                                            onPressed: () {
                                              BlocProvider.of<ReadingUIBloc>(
                                                      context)
                                                  .add(
                                                      ToggleChapterOutlineEvent());
                                            }),
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
                                        // Author profile button
                                        ReadingIconButton(
                                          icon: Icon(Icons.person),
                                          onPressed: () {},
                                        ),

                                        LibraryMenuButton(bookId: this.bookId),

                                        // Chapter Feedback
                                        ReadingIconButton(
                                          icon: Icon(Icons.comment),
                                          label: "Feedback",
                                          onPressed: () {
                                            BlocProvider.of<ReadingUIBloc>(
                                                    context)
                                                .add(ToggleFeedbackBarEvent());
                                          },
                                        ),
                                      ])))
                        ])));
          },
        );
      });
    });
  }
}
