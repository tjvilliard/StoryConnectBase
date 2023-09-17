import 'package:flutter/material.dart';

/// Contains Static Components used by the login and registration cases.
class StaticComponents {
  // Width Constant
  static double elementWidth = 360;

  // Height Constant
  static double elementHeight = 57;

  // Element Font Size Constant
  static double fontSize = 15;

  // StoryConnect Sign in page label
  static Container storyConnectLabel = Container(
      padding: EdgeInsets.only(top: 0, bottom: 25),
      child: Text("StoryConnect",
          style: TextStyle(
              fontSize: 42, color: const Color.fromARGB(255, 37, 74, 105))));

  // Text label for sign in page
  static Container signInLabel = Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Text("Sign In", style: TextStyle(fontSize: 22)));

  // Text label for sign up page
  static Container signUpLabel = Container(
      padding: EdgeInsets.only(top: 25, bottom: 25),
      child: Text("Register", style: TextStyle(fontSize: 25)));

  // Settings for text field style
  static TextStyle textFieldStyle = TextStyle(fontSize: fontSize, height: 1.05);

  // Settings for element border style
  static BorderRadius elementRadius = BorderRadius.circular(7.0);

  // Settings for text-field border style
  static OutlineInputBorder textFieldBorderStyle =
      OutlineInputBorder(borderRadius: elementRadius);

  // Settings for button border style
  static ButtonStyle buttonStyle = ButtonStyle(
      textStyle: MaterialStatePropertyAll(TextStyle(fontSize: fontSize)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: elementRadius)));

  // Vertical separator component
  static Widget verticalSeparator = VerticalDivider(
      thickness: 2, width: 20, color: Color.fromARGB(255, 36, 91, 136));

  /// Creates wrapper Container for a field with optional width.
  static Container fieldContainer(Widget field, {double? width = null}) {
    if (width != null) {
      return Container(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          width: width,
          child: field);
    } else {
      return Container(
          padding: EdgeInsets.only(top: 5, bottom: 5), child: field);
    }
  }

  /// Creates wrapper Container for a button with optional width.
  static Container buttonContainer(Widget button, {double? width = null}) {
    if (width != null) {
      return Container(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          width: width,
          height: elementHeight,
          child: button);
    } else {
      return Container(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          height: elementHeight,
          child: button);
    }
  }

  /// Creates wrapper Container and Row class with buttons.
  static Container signUpAndForgotWidget(Widget button1, Widget button2) {
    return Container(
        padding: EdgeInsets.only(top: 5, bottom: 5),
        child: IntrinsicHeight(
            child: Row(children: [
          Expanded(child: button1),
          verticalSeparator,
          Expanded(child: button2)
        ])));
  }
}
