import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
  const EmptyContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Highlight text to ask a specific question, or ask about the entire chapter.",
              style: Theme.of(context).textTheme.titleSmall,
            )));
  }
}
