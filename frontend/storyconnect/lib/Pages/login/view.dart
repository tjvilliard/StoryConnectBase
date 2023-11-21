import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/login/components/email_field.dart';
import 'package:storyconnect/Pages/login/components/layout_constants.dart';
import 'package:storyconnect/Pages/login/components/login_button.dart';
import 'package:storyconnect/Pages/login/components/password_field.dart';
import 'package:storyconnect/Pages/login/components/recovery_button.dart';
import 'package:storyconnect/Pages/login/components/register_page_button.dart';
import 'package:storyconnect/Pages/login/components/stay_signed_in_box.dart';

class LoginPageView extends StatelessWidget {
  static Color charcoalBlue = const Color(0xFF28536B);

  const LoginPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Center(
                child: Container(
              alignment: Alignment.bottomCenter,
              constraints: const BoxConstraints(maxWidth: LoginPageConstants.maxWidth),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        padding: const EdgeInsets.only(),
                        child: Text(
                          style: TextStyle(fontSize: 42, color: charcoalBlue),
                          "StoryConnect",
                        )),
                    const EmailField(),
                    const PasswordField(),
                    const StaySignedInBox(),
                    const LoginButton(),
                    Container(
                        width: LoginPageConstants.maxWidth,
                        padding: LoginPageConstants.verticalPadding,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const RegisterLinkButton(),
                            SizedBox(
                                height: 32,
                                child: VerticalDivider(
                                    indent: 0, endIndent: 0, thickness: 1.5, width: 15, color: charcoalBlue)),
                            const Expanded(child: RecoveryLinkButton())
                          ],
                        )),
                  ]),
            ))
          ],
        ));
  }
}
