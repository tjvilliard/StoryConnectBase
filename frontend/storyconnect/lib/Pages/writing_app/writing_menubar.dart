import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/writing_app/writing_ui_bloc.dart';

class WritingMenuBar extends StatelessWidget {
  const WritingMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).dividerColor.withOpacity(0.25),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: Offset(0, 1))
            ],
            border: Border(
                bottom: BorderSide(
                    color: Theme.of(context).dividerColor, width: 1.5))),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          MenuBar(children: [
            MenuItemButton(
              leadingIcon: Icon(FontAwesomeIcons.list),
              child: Text("Chapters"),
              onPressed: () {
                BlocProvider.of<WritingUIBloc>(context).toggleChapterOutline();
              },
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