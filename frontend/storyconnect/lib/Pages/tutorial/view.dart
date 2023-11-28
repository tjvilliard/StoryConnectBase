import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TutorialPopupWidget extends StatelessWidget {
  const TutorialPopupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Stack(children: [
      Container(
          // constraints: const BoxConstraints(maxWidth: 450, minHeight: 500),
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Tutorial", style: Theme.of(context).textTheme.displaySmall),
              ],
            ),
            const SizedBox(height: 20),
            const SingleChildScrollView(
                child: Column(
              children: [],
            ))
          ])),
      Positioned(
          top: 10,
          right: 20,
          child: IconButton.filledTonal(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(FontAwesomeIcons.x)))
    ]));
  }
}
