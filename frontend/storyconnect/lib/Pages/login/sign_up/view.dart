import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/login/sign_up/sign_up_form.dart';

/// Builds around the Widget for a different kind of login.
class SignUpWidget extends StatelessWidget {
  static Color charcoalBlue = Color(0xFF28536B);

  const SignUpWidget();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(top: 75, bottom: 75),
          constraints: BoxConstraints(
              minWidth: 400, minHeight: 400, maxHeight: 425, maxWidth: 400),
          decoration: BoxDecoration(
              border: Border.all(width: 1.5, color: charcoalBlue),
              borderRadius: BorderRadius.circular(10)),
          child: SignUpForm()),
      actions: <Widget>[],
    );
  }
}
