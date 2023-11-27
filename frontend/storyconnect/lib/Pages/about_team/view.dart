import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:storyconnect/Services/url_service.dart';
import 'package:storyconnect/Widgets/custom_scaffold.dart';
import 'package:storyconnect/Widgets/header.dart';
import 'package:storyconnect/Widgets/profile_card/view.dart';

class AboutTeamWidget extends StatefulWidget {
  const AboutTeamWidget({super.key});

  @override
  AboutTeamWidgetState createState() => AboutTeamWidgetState();
}

class AboutTeamWidgetState extends State<AboutTeamWidget> {
  static const String dallinUid = "nyzEhr9I2hOigmkpbjaf47Gvc4C2";
  static const String davidUid = "mJjGhxkCzkYhap6YI9eWENxf7bz1";

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        navigateBackFunction: () {
          final beamed = Beamer.of(context).beamBack();
          if (!beamed) {
            Beamer.of(context).beamToNamed(PageUrls.login);
          }
        },
        body: const SingleChildScrollView(
            child: Column(
          children: [
            Header(
              alignment: WrapAlignment.center,
              title: "About the Team",
            ),
            ProfileCardWidget(
              uid: dallinUid,
              forceNoEdit: true,
            ),
            ProfileCardWidget(
              uid: davidUid,
              forceNoEdit: true,
            ),

            // Novella's

            //Tanner's

            SizedBox(
              height: 50,
            )
          ],
        )));
  }
}
