import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/feedback/state/feedback_bloc.dart';

class FeedbackTypeSelector extends StatelessWidget {
  const FeedbackTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedbackBloc, FeedbackState>(builder: (context, state) {
      return SegmentedButton<FeedbackType>(
        segments: const <ButtonSegment<FeedbackType>>[
          ButtonSegment<FeedbackType>(
            value: FeedbackType.suggestion,
            label: Text('Suggestion'),
          ),
          ButtonSegment<FeedbackType>(
            value: FeedbackType.comment,
            label: Text('Comment'),
          ),
        ],
        selected: {state.selectedFeedbackType},
        onSelectionChanged: (Set<FeedbackType> newSelection) {
          context.read<FeedbackBloc>().add(FeedbackTypeChanged(
                newSelection.first,
              ));
        },
      );
    });
  }
}
