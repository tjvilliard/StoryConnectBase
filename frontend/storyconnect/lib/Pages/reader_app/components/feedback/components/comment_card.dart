import 'package:flutter/material.dart';
import 'package:storyconnect/Models/text_annotation/feedback.dart';

class CommentCardWidget extends StatelessWidget {
  final WriterFeedback feedbackItem;

  const CommentCardWidget({super.key, required this.feedbackItem});

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(minHeight: 150),
        child: Card(
            margin: const EdgeInsets.all(5),
            elevation: 5,
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                        alignment: Alignment.topCenter,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Chapter ${feedbackItem.chapterId}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .apply(fontStyle: FontStyle.italic)),
                            ])),
                    Container(
                        alignment: Alignment.topCenter,
                        constraints:
                            const BoxConstraints(minHeight: 10, maxHeight: 100),
                        child: Text(feedbackItem.comment!,
                            style: Theme.of(context).textTheme.bodySmall)),
                  ],
                ))));
  }
}
