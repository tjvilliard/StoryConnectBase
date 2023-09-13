import 'package:flutter/material.dart';
import 'package:storyconnect/Widgets/book_widget.dart';

class CurrentWorksCard extends StatelessWidget {
  const CurrentWorksCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        child: Card(
            child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(children: [
                  Text(
                    "Current Works",
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  // horizontally scrollable list of books
                  Expanded(
                      child: ListView.separated(
                          separatorBuilder: (context, index) {
                            return SizedBox(width: 20);
                          },
                          scrollDirection: Axis.horizontal,
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return SizedBox(
                                width: 150,
                                height: 200,
                                child: BookWidget(
                                  title: "The Book of the New Sun",
                                  coverCDN: "",
                                ));
                          }))
                ]))));
  }
}
