import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:storyconnect/Services/Authentication/sign_out_service.dart';
import 'package:storyconnect/Widgets/app_nav/appbar_button.dart';

class CustomAppBarMenu extends MenuAnchor {
  final BuildContext context;

  CustomAppBarMenu({Key? key, required this.context})
      : super(
            style: MenuStyle(
              surfaceTintColor: MaterialStatePropertyAll(Colors.white70),
            ),
            //alignmentOffset: ,
            menuChildren: [
              AppBarMenuButton(
                  context: context,
                  onPressed: () {},
                  child: RichText(
                      text: TextSpan(children: [
                    WidgetSpan(
                        child: Icon(FontAwesomeIcons.envelope, size: 24)),
                    TextSpan(
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: GoogleFonts.ramabhadra().fontFamily),
                        text: " Inbox")
                  ]))),
              AppBarMenuButton(
                  context: context,
                  onPressed: () {},
                  child: RichText(
                      text: TextSpan(children: [
                    WidgetSpan(child: Icon(FontAwesomeIcons.bell, size: 24)),
                    TextSpan(
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: GoogleFonts.ramabhadra().fontFamily),
                        text: " Notifications")
                  ]))),
              AppBarMenuButton(
                  context: context,
                  onPressed: () {},
                  child: RichText(
                      text: TextSpan(children: [
                    WidgetSpan(child: Icon(Icons.settings, size: 24)),
                    TextSpan(
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: GoogleFonts.ramabhadra().fontFamily),
                        text: " Settings")
                  ]))),
              AppBarMenuButton(
                  context: context,
                  onPressed: () {
                    SignOutService().signOut();
                    Beamer.of(context).beamToNamed("/");
                  },
                  child: RichText(
                      text: TextSpan(children: [
                    WidgetSpan(
                        child:
                            Icon(FontAwesomeIcons.rightFromBracket, size: 24)),
                    TextSpan(
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: GoogleFonts.ramabhadra().fontFamily),
                        text: " Sign Out")
                  ]))),
            ],
            builder: (BuildContext context, MenuController controller,
                Widget? child) {
              return AppBarIconButton(
                  icon: Icon(Icons.person_outline),
                  onPressed: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  });
            });
}
