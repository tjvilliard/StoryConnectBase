import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/login/components/layout_constants.dart';
import 'package:storyconnect/Pages/registration/components/confirm_password_field.dart';
import 'package:storyconnect/Pages/registration/components/email_field.dart';
import 'package:storyconnect/Pages/registration/components/password_field.dart';
import 'package:storyconnect/Pages/registration/components/register_button.dart';

class RegistrationPageView extends StatelessWidget {
  static Color charcoalBlue = Color(0xFF28536B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Center(
                child: Container(
              constraints:
                  BoxConstraints(maxWidth: LoginPageConstants.maxWidth),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(),
                    child: Text(
                      style: TextStyle(fontSize: 42, color: charcoalBlue),
                      "StoryConnect",
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(),
                      child: Text(
                          style:
                              Theme.of(context).textTheme.titleMedium!.apply(),
                          "Get Started With A Free Account!")),

                  Container(
                      padding: EdgeInsets.only(),
                      child: Text(
                          style: Theme.of(context).textTheme.bodySmall!.apply(),
                          "Start discovering new Stories or write some of your own.")),
                  // Options for registering with:
                  // Google, Facebook, Apple, etc...

                  EmailField(),
                  PasswordField(),
                  ConfirmPasswordField(),
                  RegistrationButton(),
                ],
              ),
            ))
          ],
        ));
  }
}
