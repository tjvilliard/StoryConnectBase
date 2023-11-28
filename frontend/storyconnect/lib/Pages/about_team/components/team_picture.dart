import 'package:flutter/material.dart';

class TeamPictureWidget extends StatelessWidget {
  const TeamPictureWidget({super.key});
  static const String teamMembers = "Novella, Tanner, David, Dallin";

  @override
  Widget build(BuildContext context) {
    // List of team members

    return Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Text("Meet the Team", style: Theme.of(context).textTheme.headlineLarge)),
              ],
            ),
            Container(
                constraints: const BoxConstraints(maxWidth: 700),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.asset('assets/team_pic.jpg'),
                )),
            const Padding(
                padding: EdgeInsets.only(left: 18, bottom: 18, top: 5),
                child: Text('Team members pictured left to right: $teamMembers')),
          ],
        ));
  }
}
