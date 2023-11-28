import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/about_team/components/project_description_card.dart';
import 'package:storyconnect/Pages/about_team/components/project_diagram.dart';
import 'package:storyconnect/Pages/about_team/components/team_profiles.dart';
import 'package:storyconnect/Services/url_service.dart';
import 'package:storyconnect/Widgets/custom_scaffold.dart';
import 'package:storyconnect/Widgets/header.dart';

class AboutTeamWidget extends StatefulWidget {
  const AboutTeamWidget({super.key});

  @override
  AboutTeamWidgetState createState() => AboutTeamWidgetState();
}

class AboutTeamWidgetState extends State<AboutTeamWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        navigateBackFunction: () {
          final beamed = Beamer.of(context).beamBack();
          if (!beamed) {
            Beamer.of(context).beamToNamed(PageUrls.login);
          }
        },
        body: SingleChildScrollView(
            child: Column(
          children: [
            Header(
              alignment: WrapAlignment.center,
              title: "StoryConnect",
              titleStyle: Theme.of(context).textTheme.displayMedium,
            ),
            ConstrainedBox(constraints: const BoxConstraints(maxWidth: 800), child: const ProjectDescriptionCard()),
            ConstrainedBox(constraints: const BoxConstraints(maxWidth: 800), child: const ProjectDiagramCard()),
            ConstrainedBox(constraints: const BoxConstraints(maxWidth: 800), child: const TeamProfilesWidget()),
            const SizedBox(
              height: 50,
            )
          ],
        )));
  }
}
