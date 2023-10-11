import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/reader_app/components/chapter/chapter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/reading_menubar/reading_menu_button.dart';
import 'package:storyconnect/Pages/reader_app/components/ui_state/reading_ui_bloc.dart';

class ReadingMenuBar extends StatelessWidget {
  const ReadingMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadingUIBloc, ReadingUIState>(
        builder: (context, uiState) {
      return BlocBuilder<ChapterBloc, ChapterBlocStruct>(
          builder: (context, chapterState) {
        return Card(
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
                                    ReadingMenuButton(
                                      icon: Icon(Icons.arrow_left),
                                      onPressed: () {},
                                    ),
                                    ReadingMenuButton(
                                        icon: Icon(FontAwesomeIcons.list),
                                        label: "Chapter ${chapterState.chapterIndex + 1}" +
                                            "/ ${chapterState.chapters.length} ",
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
                                  textDirection: TextDirection.rtl,
                                  overflowAlignment: OverflowBarAlignment.start,
                                  children: [
                                    ReadingMenuButton(
                                      icon: Icon(Icons.person),
                                      onPressed: () {},
                                    ),

                                    // Add / Remove Story from Library
                                    ReadingMenuButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {},
                                    ),

                                    // Chapter Feedback
                                    ReadingMenuButton(
                                      icon: Icon(Icons.comment),
                                      label: "Feedback",
                                      onPressed: () {},
                                    ),

                                    // Navigate Chapter Forward
                                    ReadingMenuButton(
                                      icon: Icon(Icons.arrow_right),
                                      onPressed: () {},
                                    ),
                                  ])))
                    ])));
      });
    });
  }
}
