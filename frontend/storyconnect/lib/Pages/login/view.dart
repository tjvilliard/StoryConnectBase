import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/login/components/sign_in_form.dart';
import 'package:storyconnect/Services/Authentication/authentication_service.dart';

///
/// Login page for the StoryConnect App
///
class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView(
          children: [Center(child: LoginWidget())],
        ));
  }
}

///
/// Manages Login Page Widget for the StoryConnect App
class LoginWidget extends StatelessWidget {
  static Color charcoalBlue = Color(0xFF28536B);

  const LoginWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.bottomCenter,
        margin: EdgeInsets.only(top: 75, bottom: 75),
        constraints: BoxConstraints(
            minWidth: 400, minHeight: 460, maxHeight: 470, maxWidth: 400),
        decoration: BoxDecoration(
            border: Border.all(width: 1.5, color: charcoalBlue),
            borderRadius: BorderRadius.circular(10)),
        child: SignInForm());
  }
}
