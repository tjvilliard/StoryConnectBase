import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class WritingHomeView extends StatelessWidget {
  const WritingHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OutlinedButton(
            onPressed: () {
              Beamer.of(context).beamToNamed('/writer/1');
            },
            child: Text("Go to book 1")),
      ),
    );
  }
}
