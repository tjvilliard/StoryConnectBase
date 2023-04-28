import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:storyconnect/Widgets/unimplemented_popup.dart';
import 'package:storyconnect/theme.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const Color white = Color(0xD3D3D3D3);
  static const Color charcoalBlue = Color(0xFF28536B);
  static Color lightCharcoalBlue = Color.alphaBlend(charcoalBlue, white);

  Future<void> showPopup(String caller, BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return UnimplementedPopup(featureName: caller);
        });
  }

  @override
  Widget build(BuildContext context) {
    Text titleText = Text('StoryConnect',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 40,
        ));

    Widget titleBox = Container(
        color: Colors.white,
        height: 139,
        alignment: Alignment.center,
        child: titleText);

    Widget signInLabel = Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(top: 10, bottom: 15, left: 50),
        child: Text('Sign In',
            textAlign: TextAlign.center, style: TextStyle(fontSize: 24)));

    //Username Field
    Widget usernameField = Container(
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

    //Password Field
    Widget passwordField = Container(
        width: 300,
        height: 75,
        padding: EdgeInsets.only(top: 10, bottom: 10),
        alignment: Alignment.center,
        child: TextField(
            obscureText: true,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: 'Password')));

    //Sign In Button
    Widget signInButton = Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        width: 310,
        height: 75,
        child: OutlinedButton(
          onPressed: () {
            print('Sign In Clicked!');
            Beamer.of(context).beamToNamed('/writer');
          },
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child:
                  Align(child: Text('Sign In', textAlign: TextAlign.center))),
        ));

    //Button Separator
    Widget separator = Row(children: <Widget>[
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
          child:
              Divider(endIndent: 30, thickness: 1.5, color: lightCharcoalBlue))
    ]);

    //Sign Up Button
    Widget signUpButton = Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        width: 310,
        height: 75,
        child: OutlinedButton(
          onPressed: () {
            showPopup("Sign Up", context);
          },
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child:
                  Align(child: Text('Sign Up', textAlign: TextAlign.center))),
        ));

    //Combines Each Widget of the login Box together.
    Widget loginbox = Container(
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
            signInButton,
            separator,
            signUpButton
          ],
        ));

    return MaterialApp(
      title: 'StoryConnect Login Page',
      theme: myTheme,
      home: Scaffold(
        body: ListView(
          children: [titleBox, Center(child: loginbox)],
        ),
      ),
    );
  }
}
