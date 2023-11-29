import 'package:flutter/material.dart';

/// A button for saving a book.
class SaveBookButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const SaveBookButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
        onPressed: onPressed,
        child: Text(
          text,
        ));
  }
}
