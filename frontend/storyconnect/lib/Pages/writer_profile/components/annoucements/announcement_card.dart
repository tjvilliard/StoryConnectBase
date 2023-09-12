import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

part 'annoucement.dart';
part 'make_annoucement_button.dart';

class AnnouncementsCard extends StatelessWidget {
  const AnnouncementsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 700,
        ),
        child: Card(
            child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text("Annoucements"),
                    SizedBox(height: 20),
                    ...List.generate(
                        3,
                        (index) => _Announcement(
                              announcement: "Announcement $index",
                            )),
                    SizedBox(height: 20),
                    // eventually there will be a check to see if the user is either an admin or the author of the profile
                    // if so, then the button will be displayed
                    _MakeAnnouncementButton(),
                  ],
                ))));
  }
}
