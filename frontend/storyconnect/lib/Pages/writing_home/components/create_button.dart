import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Services/url_service.dart';

class CreateBookButton extends StatelessWidget {
  const CreateBookButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      icon: Icon(FontAwesomeIcons.plus),
      label: Text("Create Book"),
      onPressed: () {
        Beamer.of(context).beamToNamed(PageUrls.createBook);
      },
    );
  }
}
