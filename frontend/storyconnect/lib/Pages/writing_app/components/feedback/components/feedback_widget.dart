import 'package:flutter/widgets.dart';
import 'package:storyconnect/Models/text_annotation/feedback.dart';
import 'package:storyconnect/Pages/writing_app/components/feedback/components/suggestion_widget.dart';

import 'comment_widget.dart';

class FeedbackCard extends StatelessWidget {
  final WriterFeedback feedback;
  const FeedbackCard({super.key, required this.feedback});

  @override
  Widget build(BuildContext context) {
    if (feedback.isSuggestion) {
      return SuggestionWidget(suggestion: feedback);
    } else {
      return CommentWidget(comment: feedback);
    }
  }
}
