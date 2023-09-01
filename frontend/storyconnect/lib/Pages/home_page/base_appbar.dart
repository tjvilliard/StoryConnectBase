import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

List<Widget> Actions = [];

AppBar baseAppBar = AppBar(actions: Actions);

AppBar signInAppBar = AppBar(actions: Actions);

class BaseAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar();
  }
}
