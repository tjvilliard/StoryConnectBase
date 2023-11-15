import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/writer_profile/models/writer_profile_models.dart';
import 'package:storyconnect/Pages/writer_profile/state/writer_profile_bloc.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

part 'annoucement_card.dart';
part 'make_annoucement_button.dart';
part 'make_announcement_dialog.dart';

class AnnouncementsCard extends StatefulWidget {
  final List<Announcement> announcements;
  final String uid;
  const AnnouncementsCard(
      {super.key, required this.announcements, required this.uid});

  @override
  _AnnouncementsCardState createState() => _AnnouncementsCardState();
}

class _AnnouncementsCardState extends State<AnnouncementsCard> {
  List<Announcement> get announcements => widget.announcements;
  String get uid => widget.uid;

  bool? _showMakeAnnouncementDialog = null;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final loggedInId = FirebaseAuth.instance.currentUser?.uid;
      if (loggedInId != null && loggedInId == uid) {
        setState(() {
          _showMakeAnnouncementDialog = true;
        });
      } else {
        setState(() {
          _showMakeAnnouncementDialog = false;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: 550, minWidth: 350, minHeight: 250),
        child: Card(
            child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Annoucements",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 20),
                    BlocBuilder<WriterProfileBloc, WriterProfileState>(
                        builder: (context, state) {
                      Widget toReturn;
                      if (state
                          .loadingStructs.annoucementsLoadingStruct.isLoading) {
                        toReturn = LoadingWidget(
                            loadingStruct:
                                state.loadingStructs.annoucementsLoadingStruct);
                      } else {
                        if (state.announcements.isEmpty) {
                          toReturn = Text("No announcements found");
                        } else {
                          toReturn = ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: 250),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: state.announcements.length,
                                  itemBuilder: (context, index) {
                                    return AnnouncementCard(
                                      announcement: announcements[index],
                                    );
                                  }));
                        }
                      }
                      return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: toReturn);
                    }),
                    SizedBox(height: 20),
                    if (_showMakeAnnouncementDialog == true)
                      _MakeAnnouncementButton()
                  ],
                ))));
  }
}
