import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CreateBookButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CreateBookButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      icon: Icon(FontAwesomeIcons.plus),
      label: Text("Create Book"),
      onPressed: onPressed,
    );
  }
}
