import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/home_page/base_appbar.dart';
import 'login_box.dart';

///
/// Login page for the StoryConnect App
///
class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: baseAppBar,
        body: ListView(
          children: [Center(child: LoginBox())],
        ));
  }
}
