import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Constants/feedback_sentiment.dart';
import 'package:storyconnect/Models/text_annotation/feedback.dart';
import 'package:storyconnect/Models/text_annotation/text_selection.dart';
import 'package:storyconnect/Pages/writing_app/components/feedback/components/navigate_button.dart';

///
class CommentCardWidget extends StatelessWidget {
  final WriterFeedback feedbackItem;

  CommentCardWidget({required this.feedbackItem});

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
                    alignment: Alignment.topCenter,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Chapter ${feedbackItem.chapterId}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .apply(fontStyle: FontStyle.italic)),
                          if (feedbackItem.isGhost == false)
                            NavigateToFeedbackButton(
                              feedback: feedbackItem,
                            )
                        ]),
                  ),
                  Container(
                    alignment: Alignment.center,
                    constraints: BoxConstraints(minHeight: 10, maxHeight: 100),
                    child: Text(feedbackItem.sentiment.description,
                        style: Theme.of(context).textTheme.titleSmall),
                  ),
                ],
              ))),
    );
  }

  /// Builds a list of sample feedback cards
  static List<CommentCardWidget> sampleCards(int ChapterId) {
    AnnotatedTextSelection initialSelection = AnnotatedTextSelection(
        offset: 0,
        offsetEnd: 0,
        chapterId: ChapterId,
        text: "",
        floating: false);

    List<WriterFeedback> commentList = <WriterFeedback>[
      WriterFeedback(
        chapterId: ChapterId,
        id: 5000,
        userId: 5000,
        selection: initialSelection,
        sentiment: FeedbackSentiment.good,
        isSuggestion: false,
        dismissed: false,
        comment: "This is a Comment",
      ),
      WriterFeedback(
        chapterId: ChapterId,
        id: 5001,
        userId: 5001,
        selection: initialSelection,
        sentiment: FeedbackSentiment.mediocre,
        isSuggestion: false,
        dismissed: false,
        comment:
            "This is a medium sized comment, This comment should have another line or two inside it.",
      ),
      WriterFeedback(
        chapterId: ChapterId,
        id: 5002,
        userId: 5002,
        selection: initialSelection,
        sentiment: FeedbackSentiment.bad,
        isSuggestion: false,
        dismissed: false,
        comment: "This is a Comment",
      )
    ];

    List<CommentCardWidget> cardList = [];

    for (WriterFeedback comment in commentList) {
      cardList.add(CommentCardWidget(feedbackItem: comment));
    }

    return cardList;
  }
}
