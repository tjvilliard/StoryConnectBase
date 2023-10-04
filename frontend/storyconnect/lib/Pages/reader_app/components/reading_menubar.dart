import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/reader_app/components/ui_state/reading_ui_bloc.dart';

class ReadingMenuBar extends StatelessWidget {
  const ReadingMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(16),
        child: Padding(
            padding: EdgeInsets.all(8),
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
                        child: Text("Chapters"),
                        onPressed: () {
                          BlocProvider.of<ReadingUIBloc>(context)
                              .add(ToggleChapterOutlineEvent());
                        }),
                  ],
                )
              ],
            )));
  }
}
