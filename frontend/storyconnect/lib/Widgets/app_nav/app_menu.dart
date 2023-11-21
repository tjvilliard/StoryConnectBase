import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Services/Authentication/sign_out_service.dart';

class CustomAppBarMenu extends StatelessWidget {
  final BuildContext context;

  const CustomAppBarMenu({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      ),
      label: const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Text("Sign Out")),
      icon: const Icon(FontAwesomeIcons.rightFromBracket),
      onPressed: () {
        SignOutService().signOut();
        Beamer.of(context).beamToNamed("/");
      },
    );
  }
}
