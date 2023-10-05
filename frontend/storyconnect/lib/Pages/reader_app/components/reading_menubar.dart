import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/reader_app/components/chapter/chapter_bloc.dart';
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    MenuBar(
                      style: MenuStyle(
                        alignment: Alignment.centerLeft,
                        maximumSize: MaterialStatePropertyAll(Size(200, 200)),
                      ),
                      children: [
                        MenuItemButton(
                            leadingIcon: Icon(FontAwesomeIcons.list),
                            child: Text(
                                "Chapter ${chapterState.chapterIndex + 1} / ${chapterState.chapters.length} "),
                            onPressed: () {
                              BlocProvider.of<ReadingUIBloc>(context)
                                  .add(ToggleChapterOutlineEvent());
                            }),
                      ],
                    )
                  ],
                )));
      });
    });
  }
}
