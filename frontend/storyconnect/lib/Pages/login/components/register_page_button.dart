import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/login/components/layout_constants.dart';
import 'package:storyconnect/Services/url_service.dart';

class RegisterLinkButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(minHeight: 56),
        padding: LoginPageConstants.verticalPadding,
        child: OutlinedButton(
            style: ButtonStyle(
                textStyle: MaterialStatePropertyAll(
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)))),
            onPressed: () {
              Beamer.of(context).beamToNamed(PageUrls.register);
            },
            child: Text("Create Account")));
    ;
  }
}
