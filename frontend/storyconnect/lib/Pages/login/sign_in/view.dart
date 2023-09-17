import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/login/sign_in/sign_in_form.dart';
import 'package:storyconnect/Pages/login/static_components.dart';

/// Login page for the StoryConnect App
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

/// Builds around the Widget for a different kind of login.
class LoginWidget extends StatelessWidget {
  static Color charcoalBlue = Color(0xFF28536B);

  const LoginWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.bottomCenter,
        constraints: BoxConstraints(
            minWidth: StaticComponents.elementWidth,
            maxWidth: StaticComponents.elementWidth),
        child: SignInForm());
  }
}
