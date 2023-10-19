import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/state/feedback_bloc.dart';

/// Widget selecting the type of feedback selected.
class FeedbackTypeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedbackBloc, FeedbackState>(
        builder: (BuildContext context, FeedbackState feedbackState) {
      return SegmentedButton<FeedbackType>(
        segments: [
          ButtonSegment<FeedbackType>(
            value: FeedbackType.comment,
            label: (Text("Comment")),
          ),
          ButtonSegment<FeedbackType>(
            value: FeedbackType.suggestion,
            label: (Text("Suggestion")),
          ),
        ],
        selected: {feedbackState.selectedFeedbackType},
        onSelectionChanged: (Set<FeedbackType> newSelection) {
          context.read<FeedbackBloc>().add(FeedbackTypeChanged(
                newSelection.first,
              ));
        },
      );
    });
  }
}
