import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Models/models.dart';

class CommentWidget extends StatelessWidget {
  final Comment comment;

  CommentWidget({required this.comment});
  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(minHeight: 150),
        child: Card(
            margin: EdgeInsets.all(5),
            elevation: 5,
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Text("Chapter ${comment.chapterId}",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .apply(fontStyle: FontStyle.italic)),
                    ),
                    Container(
                      alignment: Alignment.center,
                      constraints:
                          BoxConstraints(minHeight: 50, maxHeight: 100),
                      child: Text(comment.comment ?? "No comment",
                          style: Theme.of(context).textTheme.titleSmall),
                    ),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: FilledButton.tonalIcon(
                            onPressed: () {},
                            icon: Icon(FontAwesomeIcons.x),
                            label: Text("Dismiss",
                                style:
                                    Theme.of(context).textTheme.labelMedium))),
                  ],
                ))));
  }
}
