import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/login/components/static_components.dart';
import 'package:storyconnect/Services/Authentication/authentication_service.dart';

///
/// Contains the State parts of the Sign In Widget
class SignUpForm extends StatefulWidget {
  final AuthenticationService _authService;

  const SignUpForm(this._authService);

  @override
  State<StatefulWidget> createState() => _signUpState(_authService);
}

///
/// Manages the state of the sign-in widget: The fields and button
/// are the components with state.
class _signUpState extends State<SignUpForm> {
  final AuthenticationService _authService;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailErrorController = TextEditingController();
  final TextEditingController _passwordErrorController =
      TextEditingController();

  bool _validateEmail = false;
  bool _validatePassword = false;

  _signUpState(this._authService);

  void _resetState() {
    setState(() {
      this._validateEmail = false;
      this._validatePassword = false;
      this._emailErrorController.text = "";
      this._passwordErrorController.text = "";
    });
  }

  void _signUp() async {
    this._resetState();

    if (this._emailController.text.isNotEmpty &&
        this._passwordController.text.isNotEmpty) {
      String? message = await this
          ._authService
          .signUp(this._emailController.text, this._passwordController.text);

      if (message != AuthenticationService.SUCCESS) {
        if (message!.contains("email")) {
          setState(() {
            this._validateEmail = true;
            this._emailErrorController.text = message;
          });
        } else if (message.contains("password")) {
          setState(() {
            this._validatePassword = true;
            this._passwordErrorController.text = message;
          });
        } else {
          setState(() {
            this._validateEmail = true;
            this._validatePassword = true;
            this._passwordErrorController.text = message;
          });
        }
      } else {
        //make api call with token and redirect to home
      }
    } else {
      setState(() {
        if (this._emailController.text.isEmpty) {
          this._validateEmail = true;
          this._emailErrorController.text = "Username should not be empty!";
        }

        if (this._passwordController.text.isEmpty) {
          this._validatePassword = true;
          this._passwordErrorController.text = "Password should not be empty!";
        }
      });
    }
  }

  Container _fieldContainer(Widget field) {
    return Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        width: 310,
        //height: 75,
        child: field);
  }

  Container _elementContainer(Widget button) {
    return Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        width: 310,
        height: 75,
        child: button);
  }

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

  ///
  ///
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

  OutlinedButton _signUpButton() {
    return OutlinedButton(
        onPressed: () => {this._signUp()}, child: Text("Sign Up"));
  }

  static Color charcoalBlue = Color(0xFF28536B);

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
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                signInLabel,
                this._fieldContainer(this._emailField()),
                this._fieldContainer(this._passwordField()),
                this._elementContainer(this._signUpButton()),
              ])),
      actions: <Widget>[],
    );
  }
}
