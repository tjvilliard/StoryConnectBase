import 'package:flutter/material.dart';
import 'package:storyconnect/Widgets/book_widget.dart';

class CurrentWorksCard extends StatelessWidget {
  const CurrentWorksCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  "Current Works",
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                // horizontally scrollable list of books
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: [
                      BookWidget(),
                      BookWidget(),
                      BookWidget(),
                      BookWidget(),
                    ])),
              ],
            )));
  }
}
