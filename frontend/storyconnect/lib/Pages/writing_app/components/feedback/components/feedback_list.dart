import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Models/text_annotation/feedback.dart';
import 'package:storyconnect/Pages/writing_app/components/feedback/components/feedback_widget.dart';
import 'package:storyconnect/Pages/writing_app/components/feedback/state/feedback_bloc.dart';

class FeedbackList extends StatelessWidget {
  final List<WriterFeedback> feedbacks;

  const FeedbackList({
    required this.feedbacks,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedbackBloc, FeedbackState>(builder: (context, state) {
      // if our feedbacks are empty, return a Card with a message
      if (feedbacks.isEmpty) {
        return Column(children: [
          Card(
            elevation: 4,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: const Text("No feedback has been provived yet"),
            ),
          ),
          const Spacer()
        ]);
      }

      return ListView.separated(
        itemCount: feedbacks.length,
        itemBuilder: (context, index) {
          return FeedbackCard(feedback: feedbacks[index]);
        },
        separatorBuilder: (context, index) {
          if (index != feedbacks.length - 1) {
            return const Divider();
          } else {
            return Container();
          }
        },
      );
    });
  }
}
