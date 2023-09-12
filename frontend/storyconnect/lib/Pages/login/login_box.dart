import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:storyconnect/Services/url_service.dart';
import 'package:storyconnect/Widgets/form_field.dart';

class LoginBox extends StatelessWidget {
  static const Color white = Color(0xD3D3D3D3);
  static const Color charcoalBlue = Color(0xFF28536B);
  static final Color lightCharcoalBlue = Color.alphaBlend(charcoalBlue, white);

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
      height: 40,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: OutlinedButton(
          onPressed: () {
            print("Sign Up Clicked!");
          },
          child: Text('Sign Up', textAlign: TextAlign.center)));

  ///
  ///
  Widget _buildSignInButton(BuildContext context) => Container(
      height: 40,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: FilledButton(
        onPressed: () => {Beamer.of(context).beamToNamed(PageUrls.writerHome)},
        child: Text('Sign In', textAlign: TextAlign.center),
      ));

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: 400),
        child: Card(
            margin: EdgeInsets.only(top: 75, bottom: 75),

            //each object in our page, from top to bottom
            child: Container(
                padding: EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text('Sign In',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displaySmall)),
                    Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: CustomFormField(label: 'Email')),
                    Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: CustomFormField(label: 'Password')),
                    this._buildSignInButton(context),
                    separator,
                    signUpButton
                  ],
                ))));
  }
}
