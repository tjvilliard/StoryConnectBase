import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WritingMenuBar extends StatelessWidget {
  const WritingMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: Row(children: [
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
                SizedBox(
                  width: 20,
                ),
                MenuItemButton(
                    leadingIcon: Icon(FontAwesomeIcons.comment),
                    child: Text("Comments")),
              ])
        ]));
  }
}
