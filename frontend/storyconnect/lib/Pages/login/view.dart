import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/login/components/email_field.dart';
import 'package:storyconnect/Pages/login/components/layout_constants.dart';
import 'package:storyconnect/Pages/login/components/login_button.dart';
import 'package:storyconnect/Pages/login/components/password_field.dart';
import 'package:storyconnect/Pages/login/components/register_page_button.dart';
import 'package:storyconnect/Services/url_service.dart';
import 'package:storyconnect/Widgets/custom_scaffold.dart';

class LoginPageView extends StatelessWidget {
  static Color charcoalBlue = const Color(0xFF28536B);

  const LoginPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      floatingActionButton: FilledButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        onPressed: () {
          Beamer.of(context).beamToNamed(PageUrls.about);
        },
        child: const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text("About the Project")),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: LoginPageConstants.maxWidth),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Image.asset("assets/splash.png"),
                const SizedBox(height: 20),
                const EmailField(),
                const PasswordField(),
                const LoginButton(),
                const RegisterLinkButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
