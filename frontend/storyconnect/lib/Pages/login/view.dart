import 'package:flutter/material.dart';
import 'package:storyconnect/theme.dart';
import 'package:storyconnect/Pages/home_page/base_app_bar.dart';
import 'login_box.dart';

///
///
class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'StoryConnect Login Page',
        theme: myTheme,
        home: Scaffold(
            appBar: baseAppBar,
            body: ListView(
              children: [Center(child: LoginBox())],
            )));
  }
}
