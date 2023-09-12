import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:storyconnect/Services/url_service.dart';

class ViewProfileButton extends StatelessWidget {
  const ViewProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        child: Text("View Profile"),
        onPressed: () {
          Beamer.of(context).beamToNamed(PageUrls.writerProfile(1));
        });
  }
}
