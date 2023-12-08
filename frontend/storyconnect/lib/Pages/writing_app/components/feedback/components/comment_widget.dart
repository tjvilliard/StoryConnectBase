import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Models/text_annotation/feedback.dart';
// import 'package:storyconnect/Models/text_annotation/feedback.dart';
import 'package:storyconnect/Pages/writing_app/components/feedback/components/navigate_button.dart';
import 'package:storyconnect/Pages/writing_app/components/feedback/state/feedback_bloc.dart';

class CommentWidget extends StatelessWidget {
  final WriterFeedback comment;

  String get commentText {
    if (comment.selection.text.isEmpty) {
      return "No text selected";
    } else {
      return comment.selection.text;
    }
  }

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
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text("Sentiment: ${comment.sentiment.description}",
                            style: Theme.of(context).textTheme.titleSmall!.apply(fontStyle: FontStyle.italic)),
                        if (comment.isGhost == false)
                          NavigateToFeedbackButton(
                            feedback: comment,
                          )
                      ]),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          alignment: Alignment.center,
                          constraints: const BoxConstraints(minHeight: 10, maxHeight: 100),
                          child: Text(commentText, style: Theme.of(context).textTheme.titleSmall),
                        )),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: FilledButton.tonalIcon(
                            onPressed: () {
                              context
                                  .read<FeedbackBloc>()
                                  .add(DismissFeedbackEvent(feedbackId: comment.id, chapterId: comment.chapterId));
                            },
                            icon: const Icon(FontAwesomeIcons.x),
                            label: Text("Dismiss", style: Theme.of(context).textTheme.labelMedium))),
                  ],
                ))));
  }
}
