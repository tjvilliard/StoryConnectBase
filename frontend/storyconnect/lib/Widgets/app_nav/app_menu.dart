import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Services/Authentication/sign_out_service.dart';

class CustomAppBarMenu extends StatelessWidget {
  final BuildContext context;

  CustomAppBarMenu({Key? key, required this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      ),
      label: Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text("Sign Out")),
      icon: Icon(FontAwesomeIcons.rightFromBracket),
      onPressed: () {
        SignOutService().signOut();
        Beamer.of(context).beamToNamed("/");
      },
    );
  }
}
