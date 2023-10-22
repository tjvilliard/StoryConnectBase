import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/reader_app/components/chapter/state/chapter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/menubar/reading_menu_button.dart';
import 'package:storyconnect/Pages/reader_app/components/ui_state/reading_ui_bloc.dart';

/// Custom Menu Bar for the Reading UI Page.
class ReadingMenuBar extends StatelessWidget {
  final int bookId;
  const ReadingMenuBar({required this.bookId, super.key});

  //height for items in bar
  static const double height = 40;
  static ShapeBorder widget_radius =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadingUIBloc, ReadingUIState>(
        builder: (context, uiState) {
      return BlocBuilder<ChapterBloc, ChapterBlocStruct>(
          builder: (context, chapterState) {
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
                                  overflowAlignment: OverflowBarAlignment.start,
                                  children: [
                                    // Previous chapter button
                                    ReadingIconButton(
                                      icon: Icon(Icons.arrow_left),

                                      // Disable the previous chapter button if we are on the first chapter
                                      onPressed: chapterState.chapterIndex == 0
                                          ? null
                                          : () {
                                              context.read<ChapterBloc>().add(
                                                  SwitchChapter(
                                                      chapterToSwitchFrom:
                                                          chapterState
                                                              .chapterIndex,
                                                      chapterToSwitchTo:
                                                          chapterState
                                                                  .chapterIndex -
                                                              1));
                                            },
                                    ),

                                    // Bring Up the Chapter Navigation Bar
                                    ReadingIconButton(
                                        icon: Icon(FontAwesomeIcons.list),
                                        label: "Chapter ${chapterState.chapterIndex + 1}" +
                                            "/${chapterState.chapters.length} ",
                                        onPressed: () {
                                          BlocProvider.of<ReadingUIBloc>(
                                                  context)
                                              .add(ToggleChapterOutlineEvent());
                                        }),
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
                                    // Author profile button
                                    ReadingIconButton(
                                      icon: Icon(Icons.person),
                                      onPressed: () {},
                                    ),

                                    // Add / Remove Story from Library
                                    ReadingIconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        BlocProvider.of<ReadingUIBloc>(context)
                                            .add(LibraryToggleEvent(
                                                bookId: this.bookId));
                                      },
                                    ),

                                    // Chapter Feedback
                                    ReadingIconButton(
                                      icon: Icon(Icons.comment),
                                      label: "Feedback",
                                      onPressed: () {
                                        BlocProvider.of<ReadingUIBloc>(context)
                                            .add(ToggleFeedbackBarEvent());
                                      },
                                    ),

                                    // Navigate Chapter Forward
                                    ReadingIconButton(
                                      icon: Icon(Icons.arrow_right),

                                      // Disable the next chapter button if we are on the first chapter.
                                      onPressed: chapterState.chapterIndex ==
                                              chapterState.chapters.length - 1
                                          ? null
                                          : () {
                                              context.read<ChapterBloc>().add(
                                                  SwitchChapter(
                                                      chapterToSwitchFrom:
                                                          chapterState
                                                              .chapterIndex,
                                                      chapterToSwitchTo:
                                                          chapterState
                                                                  .chapterIndex +
                                                              1));
                                            },
                                    ),
                                  ])))
                    ])));
      });
    });
  }
}
