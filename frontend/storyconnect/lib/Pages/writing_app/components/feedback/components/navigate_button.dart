import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Models/text_annotation/feedback.dart';

class NavigateToFeedbackButton extends StatelessWidget {
  final WriterFeedback feedback;

  const NavigateToFeedbackButton({super.key, required this.feedback});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 25.0,
        width: 30.0,
        child: IconButton.filled(
          padding: EdgeInsets.all(0),
          onPressed: () {},
          icon: Icon(FontAwesomeIcons.arrowRight, size: 15),
        ));
  }
}
