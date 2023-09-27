import 'package:flutter/material.dart';
import 'package:storyconnect/Widgets/book_widget.dart';

class CurrentWorksCard extends StatefulWidget {
  const CurrentWorksCard({super.key});

  @override
  CurrentWorksCardState createState() => CurrentWorksCardState();
}

class CurrentWorksCardState extends State<CurrentWorksCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: 550),
        height: 300,
        child: Card(
            child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(children: [
                  Text(
                    "Current Works",
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 20), // horizontally scrollable list of books
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
