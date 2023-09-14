import 'package:flutter/material.dart';

part 'activity_card.dart';

class RecentActivityCard extends StatelessWidget {
  const RecentActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  "Recent Activity",
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 20),
                ...List.generate(
                    3,
                    (index) => _ActivityCard(
                          activity: "Author X did activity: $index",
                        ))
              ],
            )));
  }
}
