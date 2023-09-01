import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/login/authentication/sign_in.dart';
import 'package:storyconnect/Pages/login/components/submission_field_widget.dart';
import 'components/components.dart';

class LoginBox extends StatefulWidget {
  @override
  State<LoginBox> createState() => LoginState();
}

///
/// Handles the State of the Login/Sign-up Page Page
///
class LoginState extends State<LoginBox> {
  TextSubmitFieldWidget _usernameWidget = new TextSubmitFieldWidget();

  LoginState() {}

  ///
  /// Builds the Sign in button.
  ///
  Widget _buildSignInButton() {
    return Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        width: 310,
        height: 75,
        child: OutlinedButton(
          onPressed: () => signIn(this._userFieldController.text,
              this._passwordFieldController.text),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child:
                  Align(child: Text('Sign In', textAlign: TextAlign.center))),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.bottomCenter,
        margin: EdgeInsets.only(top: 75, bottom: 75),
        constraints: BoxConstraints(
            minWidth: 400, minHeight: 400, maxHeight: 425, maxWidth: 400),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1.5, color: lightCharcoalBlue),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            signInLabel,
            usernameField,
            passwordField,
            this._buildSignInButton(),
            separator,
            signUpButton
          ],
        ));
  }
}
