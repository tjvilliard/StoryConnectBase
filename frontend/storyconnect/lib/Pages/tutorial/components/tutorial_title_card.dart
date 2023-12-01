import 'package:flutter/material.dart';

class TutorialTitleCard extends StatelessWidget {
  const TutorialTitleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Introduction", style: Theme.of(context).textTheme.displaySmall),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
                child: Text("Welcome to StoryConnect! This tutorial will walk you through the basics of using the app.",
                    style: Theme.of(context).textTheme.titleMedium)),
          ],
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
