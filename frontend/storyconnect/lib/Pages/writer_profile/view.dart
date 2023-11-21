import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writer_profile/components/annoucements/announcements.dart';

import 'package:storyconnect/Pages/writer_profile/components/activity/recent_activity_card.dart';
import 'package:storyconnect/Pages/writer_profile/components/current_works_card.dart';
import 'package:storyconnect/Pages/writer_profile/components/profile/profile_card.dart';
import 'package:storyconnect/Pages/writer_profile/state/writer_profile_bloc.dart';
import 'package:storyconnect/Services/url_service.dart';
import 'package:storyconnect/Widgets/body.dart';
import 'package:storyconnect/Widgets/custom_scaffold.dart';
import 'package:storyconnect/Widgets/header.dart';

class WriterProfileWidget extends StatefulWidget {
  final String uid;
  const WriterProfileWidget({super.key, required this.uid});

  @override
  WriterProfilePageState createState() => WriterProfilePageState();
}

class WriterProfilePageState extends State<WriterProfileWidget> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WriterProfileBloc>().add(WriterProfileLoadEvent(uid: widget.uid));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  static const duration = Duration(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        navigateBackFunction: () {
          final beamed = Beamer.of(context).beamBack();
          if (!beamed) {
            Beamer.of(context).beamToNamed(PageUrls.writerHome);
          }
        },
        body: BlocConsumer<WriterProfileBloc, WriterProfileState>(
            listenWhen: (previous, current) => previous.responseMessages != current.responseMessages,
            listener: (context, state) {
              if (state.responseMessages.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.responseMessages.last), duration: const Duration(seconds: 6)));
                // clear the messages
                context.read<WriterProfileBloc>().add(const ClearLastResponseEvent());
              }
            },
            builder: (context, state) => LayoutBuilder(
                  builder: (context, constraints) {
                    return ListView(children: [
                      Column(mainAxisSize: MainAxisSize.min, children: [
                        const Header(
                          title: "Profile Page",
                          subtitle: "",
                        ),
                        Body(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ProfileCard(uid: widget.uid),
                            const CurrentWorksCard(),
                            Wrap(
                              alignment: WrapAlignment.center,
                              children: [
                                AnnouncementsCard(uid: widget.uid, announcements: state.announcements),
                                const RecentActivityCard(),
                              ],
                            )
                          ],
                        ))
                      ])
                    ]);
                  },
                )));
  }
}
