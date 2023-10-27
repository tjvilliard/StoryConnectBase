import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/login/components/sign_in_widget.dart';

class LoginPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: ListView(
          scrollDirection: Axis.vertical,
          children: [Center(child: SignInWidget())],
        ));
  }
}
