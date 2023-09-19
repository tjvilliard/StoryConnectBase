import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Models/models.dart';

class NavigateToFeedbackButton extends StatelessWidget {
  final Comment? comment;
  final Comment? suggestion;

  const NavigateToFeedbackButton({super.key, this.comment, this.suggestion});

  @override
  Widget build(BuildContext context) {
    assert(comment != null || suggestion != null);

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
