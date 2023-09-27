import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/writer_profile/components/annoucements/announcement_card.dart';
import 'package:storyconnect/Pages/writer_profile/components/current_works_card.dart';
import 'package:storyconnect/Pages/writer_profile/components/profile_card.dart';
import 'package:storyconnect/Pages/writer_profile/components/activity/recent_activity_card.dart';
import 'package:storyconnect/Widgets/body.dart';
import 'package:storyconnect/Widgets/custom_scaffold.dart';
import 'package:storyconnect/Widgets/header.dart';

class WriterProfileWidget extends StatelessWidget {
  final int? userId;
  const WriterProfileWidget({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appBar: AppBar(),
        navigateBackFunction: () {
          Beamer.of(context).beamBack();
        },
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
                child: ListView(children: [
              Column(mainAxisSize: MainAxisSize.min, children: [
                Header(
                  title: "Profile Page",
                  subtitle: "",
                ),
                Body(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ProfileCard(),
                    AnnouncementsCard(),
                    Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                      children: [
                        CurrentWorksCard(),
                        RecentActivityCard(),
                      ],
                    )
                  ],
                ))
              ])
            ]));
          },
        ));
  }
}
