import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Services/url_service.dart';

class ViewProfileButton extends StatelessWidget {
  const ViewProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
        icon: Icon(FontAwesomeIcons.user),
        onPressed: () async {
          final uid = await FirebaseAuth.instance.currentUser?.uid;
          if (uid == null) {
            return;
          }
          Beamer.of(context).beamToNamed(PageUrls.writerProfile(uid));
        });
  }
}
