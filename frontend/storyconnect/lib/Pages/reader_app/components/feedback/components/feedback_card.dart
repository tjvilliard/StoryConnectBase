import 'package:flutter/material.dart';
import 'package:storyconnect/Models/text_annotation/feedback.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/components/comment_card.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/components/suggestion_card.dart';

class FeedbackCardWidget extends StatelessWidget {
  final WriterFeedback feedback;
  const FeedbackCardWidget({super.key, required this.feedback});

  @override
  Widget build(BuildContext context) {
    if (feedback.isSuggestion) {
      return SuggestionCardWidget(
        feedbackItem: feedback,
      );
    } else {
      return CommentCardWidget(
        feedbackItem: feedback,
      );
    }
  }
}
