import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/login/sign_up/sign_up_form.dart';

/// Builds around the Widget for a different kind of login.
class SignUpWidget extends StatelessWidget {
  static Color charcoalBlue = Color(0xFF28536B);

  const SignUpWidget();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
          alignment: Alignment.center,
          constraints: BoxConstraints(
              minWidth: 400, minHeight: 400, maxHeight: 425, maxWidth: 400),
          child: SignUpForm()),
      actions: <Widget>[],
    );
  }
}
