import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Models/text_annotation/feedback.dart';
// import 'package:storyconnect/Models/text_annotation/feedback.dart';
import 'package:storyconnect/Pages/writing_app/components/feedback/components/navigate_button.dart';

class CommentWidget extends StatelessWidget {
  final WriterFeedback comment;

  const CommentWidget({super.key, required this.comment});
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Chapter ${comment.chapterId}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .apply(fontStyle: FontStyle.italic)),
                            if (comment.isGhost == false)
                              NavigateToFeedbackButton(
                                feedback: comment,
                              )
                          ]),
                    ),
                    Container(
                      alignment: Alignment.center,
                      constraints:
                          const BoxConstraints(minHeight: 10, maxHeight: 100),
                      child: Text(comment.sentiment.description,
                          style: Theme.of(context).textTheme.titleSmall),
                    ),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: FilledButton.tonalIcon(
                            onPressed: () {},
                            icon: const Icon(FontAwesomeIcons.x),
                            label: Text("Dismiss",
                                style:
                                    Theme.of(context).textTheme.labelMedium))),
                  ],
                ))));
  }
}
