import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/feedback/state/feedback_bloc.dart';
import 'package:storyconnect/Widgets/description_popup.dart';

class GhostFeedbackCheckbox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedbackBloc, FeedbackState>(builder: (context, state) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(),
            Row(
              children: [
                Text('Show Ghost Comments:'),
                Checkbox(
                  value: state.showGhostFeedback,
                  onChanged: (_) => context
                      .read<FeedbackBloc>()
                      .add(ToggleGhostFeedbackEvent()),
                ),
              ],
            ),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return DescriptionPopup(
                            featureName: "Ghost Comment",
                            description:
                                "Ghost comments are comments that are no longer the same as the text they were originally commenting on, or may have been deleted entirely. They still might be useful, so you can choose to show them, or hide them.");
                      });
                },
                icon: Icon(Icons.info_outline_rounded)),
          ],
        ),
      );
    });
  }
}
