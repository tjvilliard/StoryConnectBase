import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/writing_app/writing_ui_bloc.dart';

class WritingMenuBar extends StatelessWidget {
  const WritingMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          MenuBar(children: [
            MenuItemButton(
              leadingIcon: Icon(FontAwesomeIcons.list),
              child: Text("Chapters"),
              onPressed: () =>
                  context.read<WritingUIBloc>().toggleChapterOutline(),
            ),
          ]),
          MenuBar(
              style: MenuStyle(
                  alignment: Alignment.centerLeft,
                  maximumSize: MaterialStatePropertyAll(Size(500, 200))),
              children: [
                MenuItemButton(
                    leadingIcon: Icon(FontAwesomeIcons.arrowRotateLeft),
                    child: Container()),
                MenuItemButton(
                    leadingIcon: Icon(FontAwesomeIcons.arrowRotateRight),
                    child: Container()),
              ]),
          MenuBar(children: [
            MenuItemButton(
                leadingIcon: Icon(FontAwesomeIcons.comment),
                child: Text("Comments"))
          ])
        ]));
  }
}
