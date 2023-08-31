import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class LoginBox extends StatelessWidget {
  static const Color white = Color(0xD3D3D3D3);
  static const Color charcoalBlue = Color(0xFF28536B);
  static final Color lightCharcoalBlue = Color.alphaBlend(charcoalBlue, white);

  ///
  ///
  final Widget signInLabel = Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(top: 10, bottom: 15, left: 50),
      child: Text('Sign In',
          textAlign: TextAlign.center, style: TextStyle(fontSize: 24)));

  ///
  ///
  final Widget usernameField = Container(
      width: 300,
      height: 75,
      padding: EdgeInsets.only(top: 10, bottom: 10),
      alignment: Alignment.center,
      child: TextField(
          obscureText: false,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Username',
          )));

  ///
  ///
  final Widget passwordField = Container(
      width: 300,
      height: 75,
      padding: EdgeInsets.only(top: 10, bottom: 10),
      alignment: Alignment.center,
      child: TextField(
          obscureText: true,
          decoration: InputDecoration(
              border: OutlineInputBorder(), labelText: 'Password')));

  ///
  ///
  final Widget separator = Row(children: <Widget>[
    Expanded(
        child: Divider(indent: 30, thickness: 1.5, color: lightCharcoalBlue)),
    Container(
        width: 35,
        height: 35,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.5),
            border: Border.all(width: 1.5, color: lightCharcoalBlue)),
        child: Text(
          "OR",
          textAlign: TextAlign.center,
        )),
    Expanded(
        child: Divider(endIndent: 30, thickness: 1.5, color: lightCharcoalBlue))
  ]);

  ///
  ///
  final Widget signUpButton = Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      width: 310,
      height: 75,
      child: OutlinedButton(
        onPressed: () {
          print("Sign Up Clicked!");
        },
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Align(child: Text('Sign Up', textAlign: TextAlign.center))),
      ));

  ///
  ///
  StatelessWidget _buildSignInButton(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        width: 310,
        height: 75,
        child: OutlinedButton(
          onPressed: () => {Beamer.of(context).beamToNamed(("/writer/home"))},
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
          borderRadius: BorderRadius.circular(10),
        ),
        //each object in our page, from top to bottom
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            signInLabel,
            usernameField,
            passwordField,
            this._buildSignInButton(context),
            separator,
            signUpButton
          ],
        ));
  }
}
