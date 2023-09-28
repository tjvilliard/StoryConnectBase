import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:storyconnect/Services/url_service.dart';

class CustomAppBar extends AppBar {
  final BuildContext context;

  CustomAppBar({Key? key, required this.context})
      : super(
            key: key,
            title: Text("Title"),
            leading: Text("LeadingWidget"),
            actions: [
              TextButton(
                  child: Text("Writing"),
                  onPressed: () {
                    Beamer.of(context).beamToNamed(PageUrls.writerHome);
                  }),
              TextButton(
                  child: Text("Reading"),
                  onPressed: () {
                    Beamer.of(context).beamToNamed(PageUrls.readerHome);
                  })
            ]);
}
