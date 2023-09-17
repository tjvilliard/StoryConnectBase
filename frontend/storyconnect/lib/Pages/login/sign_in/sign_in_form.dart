import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import 'package:storyconnect/Pages/login/sign_up/view.dart';
import 'package:storyconnect/Pages/login/static_components.dart';
import 'package:storyconnect/Services/Authentication/sign_in_service.dart';
import 'package:storyconnect/Widgets/unimplemented_popup.dart';

/// Contains the State parts of the Sign In Widget
class SignInForm extends StatefulWidget {
  const SignInForm();

  @override
  State<StatefulWidget> createState() => _signInState();
}

/// Manages the state of the sign-in widget: The fields and button
/// are the components with state.
class _signInState extends State<SignInForm> {
  final SignInService _signInService = SignInService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailErrorController = TextEditingController();
  final TextEditingController _passwordErrorController =
      TextEditingController();

  bool _validateEmail = false;
  bool _validatePass = false;

  void _resetState() {
    setState(() {
      this._validateEmail = false;
      this._validatePass = false;
      this._emailErrorController.text = "";
      this._passwordErrorController.text = "";
    });
  }

  /// Attempts a sign in and/or sets the state of
  /// the page's fields.
  Future<void> _signIn() async {
    this._resetState();

    // If one of the fields is empty
    if (this._emailController.text.isEmpty) {
      setState(() {
        this._emailErrorController.text = "Email cannot be empty!";
        this._validateEmail = true;
      });
    }
    if (this._passwordController.text.isEmpty) {
      setState(() {
        this._passwordErrorController.text = "Password cannot be empty!";
        this._validatePass = true;
      });
      return;
    }

    // If the fields contain data, attempt a sign-in
    if (this._emailController.text.isNotEmpty &&
        this._passwordController.text.isNotEmpty) {
      String Code = await this._signInService.signIn(
          this._emailController.text, this._passwordController.text) as String;

      // If the Sign-In attempt was not successful
      if (Code != this._signInService.SUCCESS) {
        setState(() {
          if (Code.contains("email")) {
            this._emailErrorController.text = Code;
            this._validateEmail = true;
          } else if (Code.contains("password")) {
            this._passwordErrorController.text = Code;
            this._validatePass = true;
          }
        });
      }
      // Complete the sign in and move on to the next page.
      else {
        Beamer.of(context).beamToNamed("/writer/home");
      }
    }
  }

  /// Builds the current state of the email field.
  TextField _emailField() {
    return TextField(
      style: StaticComponents.textFieldStyle,
      controller: this._emailController,
      obscureText: false,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.email_rounded),
          border: StaticComponents.textFieldBorderStyle,
          labelText: 'Email',
          errorText:
              this._validateEmail ? this._emailErrorController.text : null),
    );
  }

  /// Builds the current state of the password field
  TextField _passwordField() {
    return TextField(
      style: StaticComponents.textFieldStyle,
      controller: this._passwordController,
      obscureText: true,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock_rounded),
          border: StaticComponents.textFieldBorderStyle,
          labelText: 'Password',
          errorText:
              this._validatePass ? this._passwordErrorController.text : null),
    );
  }

  /// Builds the sign in button
  OutlinedButton _signInButton() {
    return OutlinedButton(
        style: StaticComponents.buttonStyle,
        onPressed: () => {this._signIn()},
        child: Text("Sign In"));
  }

  /// Builds the sign-up button
  OutlinedButton _signUpButton() {
    return OutlinedButton(
        style: StaticComponents.buttonStyle,
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => SignUpWidget());
        },
        child: Text("Register"));
  }

  OutlinedButton _forgotPasswordButton() {
    return OutlinedButton(
        style: StaticComponents.buttonStyle,
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                  UnimplementedPopup(featureName: "Password Reset"));
        },
        child: Text("Forgot Password?"));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          StaticComponents.storyConnectLabel,
          StaticComponents.signInLabel,
          StaticComponents.fieldContainer(this._emailField(),
              width: StaticComponents.elementWidth),
          StaticComponents.fieldContainer(this._passwordField(),
              width: StaticComponents.elementWidth),
          StaticComponents.buttonContainer(this._signInButton(),
              width: StaticComponents.elementWidth),
          StaticComponents.signUpAndForgotWidget(
              this._signUpButton(), this._forgotPasswordButton()),
        ]);
  }
}
