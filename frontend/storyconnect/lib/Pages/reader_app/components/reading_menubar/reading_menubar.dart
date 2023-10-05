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
                    MenuBar(
                      style: MenuStyle(
                        alignment: Alignment.centerLeft,
                        maximumSize: MaterialStatePropertyAll(Size(800, 200)),
                      ),
                      children: [
                        // Navigate Chapter Left
                        ReadingMenuButton(
                          leadingIcon: Icon(Icons.arrow_left),
                          onPressed: () {},
                          alignment: Alignment.centerLeft,
                        ),

                        ReadingMenuButton(
                          leadingIcon: Icon(FontAwesomeIcons.list),
                          content:
                              "Chapter ${chapterState.chapterIndex + 1} / ${chapterState.chapters.length} ",
                          onPressed: () {
                            BlocProvider.of<ReadingUIBloc>(context)
                                .add(ToggleChapterOutlineEvent());
                          },
                          alignment: Alignment.centerLeft,
                        ),

                        // Author Profile Button

                        // Add / Remove Story from Library

                        // Chapter Feedback
                      ],
                    ),

                    //Right Aligned menu items
                    MenuBar(
                      style: MenuStyle(
                        alignment: Alignment.centerRight,
                        maximumSize: MaterialStatePropertyAll(
                            Size(double.infinity, 200)),
                      ),
                      children: [
                        // Author Profile Button
                        ReadingMenuButton(
                          leadingIcon: Icon(Icons.person),
                          onPressed: () {},
                          alignment: Alignment.centerRight,
                        ),

                        // Add / Remove Story from Library
                        ReadingMenuButton(
                          leadingIcon: Icon(Icons.add),
                          onPressed: () {},
                          alignment: Alignment.centerRight,
                        ),

                        // Chapter Feedback
                        ReadingMenuButton(
                          leadingIcon: Icon(Icons.comment),
                          content: "Feedback",
                          onPressed: () {},
                          alignment: Alignment.centerRight,
                        ),

                        // Navigate Chapter Forward
                        ReadingMenuButton(
                          leadingIcon: Icon(Icons.arrow_right),
                          onPressed: () {},
                          alignment: Alignment.centerRight,
                        ),
                      ],
                    )
                  ],
                )));
      });
    });
  }
}
