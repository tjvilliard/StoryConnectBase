import 'package:flutter/material.dart';

class SaveBookButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const SaveBookButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
        child: Text(
          text,
        ),
        onPressed: onPressed);
  }
}
