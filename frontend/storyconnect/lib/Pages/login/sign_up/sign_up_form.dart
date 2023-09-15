import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import 'package:storyconnect/Pages/login/static_components.dart';
import 'package:storyconnect/Services/Authentication/sign_up_service.dart';

/// Contains the State parts of the Sign In Widget
class SignUpForm extends StatefulWidget {
  const SignUpForm();

  @override
  State<StatefulWidget> createState() => _signUpState();
}

/// Manages the state of the sign-in widget: The fields and button
/// are the components with state.
class _signUpState extends State<SignUpForm> {
  final SignUpService _signUpService = SignUpService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailErrorController = TextEditingController();
  final TextEditingController _passwordErrorController =
      TextEditingController();

  bool _validateEmail = false;
  bool _validatePassword = false;

  _signUpState();

  void _resetState() {
    setState(() {
      this._validateEmail = false;
      this._validatePassword = false;
      this._emailErrorController.text = "";
      this._passwordErrorController.text = "";
    });
  }

  /// Attempts a sign up and/or sets the state of
  /// the pop-up's fields
  void _signUp() async {
    this._resetState();

    // If one of the fields is empty
    if (this._emailController.text.isEmpty) {
      setState(() {
        this._emailErrorController.text = "Email cannot be empty!";
        this._validateEmail = true;
      });
      return;
    }
    if (this._passwordController.text.isEmpty) {
      setState(() {
        this._passwordErrorController.text = "Password cannot be empty!";
        this._validatePassword = true;
      });
      return;
    }

    // If the fields contain data, attempt a sign-in
    if (this._emailController.text.isNotEmpty &&
        this._passwordController.text.isNotEmpty) {
      String Code = await this._signUpService.signUp(
          this._emailController.text, this._passwordController.text) as String;

      // If the Sign-In attempt was not successful
      if (Code != this._signUpService.SUCCESS) {
        setState(() {
          if (Code.contains("email")) {
            this._emailErrorController.text = Code;
            this._validateEmail = true;
          } else if (Code.contains("password")) {
            this._passwordErrorController.text = Code;
            this._validatePassword = true;
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
      controller: this._emailController,
      obscureText: false,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Username',
          errorText:
              this._validateEmail ? this._emailErrorController.text : null),
    );
  }

  /// Builds the current state of the password field
  TextField _passwordField() {
    return TextField(
      controller: this._passwordController,
      obscureText: true,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Password',
          errorText: this._validatePassword
              ? this._passwordErrorController.text
              : null),
    );
  }

  /// Builds the sign-up button
  OutlinedButton _signUpButton() {
    return OutlinedButton(
        onPressed: () => {this._signUp()}, child: Text("Sign Up"));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          StaticComponents.signInLabel,
          StaticComponents.fieldContainer(this._emailField()),
          StaticComponents.fieldContainer(this._passwordField()),
          StaticComponents.elementContainer(this._signUpButton()),
        ]);
  }
}
