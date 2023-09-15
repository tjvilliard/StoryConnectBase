import 'package:flutter/material.dart';

class StaticComponents {
  static Widget signInLabel = Container(
      padding: EdgeInsets.only(top: 25, bottom: 25),
      child: Text("StoryConnect", style: TextStyle(fontSize: 25)));

  static Widget separator = Divider(
    thickness: .5,
    indent: 50,
    endIndent: 50,
    color: Colors.white,
  );

  static Container fieldContainer(Widget field) {
    return Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        width: 310,
        //height: 75,
        child: field);
  }

  static Container elementContainer(Widget button) {
    return Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        width: 310,
        height: 75,
        child: button);
  }
}
