import 'package:flutter/material.dart';

class SaveBookButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const SaveBookButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: FilledButton.icon(
            label: Text(
              text,
            ),
            icon: Icon(Icons.add),
            onPressed: () => onPressed.call()));
  }
}
