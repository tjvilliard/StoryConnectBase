import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/state/feedback_bloc.dart';

/// Widget selecting the type of feedback selected.
class FeedbackTypeSelector extends StatelessWidget {
  const FeedbackTypeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedbackBloc, FeedbackState>(
        builder: (BuildContext context, FeedbackState feedbackState) {
      return SegmentedButton<FeedbackType>(
        segments: const <ButtonSegment<FeedbackType>>[
          ButtonSegment<FeedbackType>(
            value: FeedbackType.suggestion,
            label: (Text("Suggestion")),
          ),
          ButtonSegment<FeedbackType>(
            value: FeedbackType.comment,
            label: (Text("Comment")),
          ),
        ],
        selected: {feedbackState.selectedFeedbackType},
        onSelectionChanged: (Set<FeedbackType> newSelection) {
          context.read<FeedbackBloc>().add(FeedbackTypeChangedEvent(
                feedbackType: newSelection.first,
              ));
        },
      );
    });
  }
}
