import 'package:flutter/material.dart';

class RegisterLinkButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: ButtonStyle(
            textStyle: MaterialStatePropertyAll(
                TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)))),
        onPressed: () {},
        child: Text("Create Account"));
  }
}
