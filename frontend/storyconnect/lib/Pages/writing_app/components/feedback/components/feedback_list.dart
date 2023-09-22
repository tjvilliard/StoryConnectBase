import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Models/text_annotation/feedback.dart';
import 'package:storyconnect/Pages/writing_app/components/feedback/components/feedback_widget.dart';
import 'package:storyconnect/Pages/writing_app/components/feedback/state/feedback_bloc.dart';

class FeedbackList extends StatelessWidget {
  final List<WriterFeedback> feedbacks;

  FeedbackList({
    required this.feedbacks,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedbackBloc, FeedbackState>(builder: (context, state) {
      return ListView.separated(
        itemCount: feedbacks.length,
        itemBuilder: (context, index) {
          return FeedbackCard(feedback: feedbacks[index]);
        },
        separatorBuilder: (context, index) {
          if (index != feedbacks.length - 1) {
            return Divider();
          } else {
            return Container();
          }
        },
      );
    });
  }
}
