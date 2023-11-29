import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/writing_app/components/feedback/state/feedback_bloc.dart';
import 'package:storyconnect/Widgets/description_popup.dart';

class GhostFeedbackCheckbox extends StatelessWidget {
  const GhostFeedbackCheckbox({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedbackBloc, FeedbackState>(builder: (context, state) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(),
          Row(
            children: [
              const Text('Show Ghost Comments:'),
              Checkbox(
                value: state.showGhostFeedback,
                onChanged: (_) => context.read<FeedbackBloc>().add(const ToggleGhostFeedbackEvent()),
              ),
            ],
          ),
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const DescriptionPopup(
                          featureName: "Ghost Comment",
                          description:
                              "Ghost comments are comments that are no longer the same as the text they were originally commenting on, or may have been deleted entirely. They still might be useful, so you can choose to show them, or hide them.");
                    });
              },
              icon: const Icon(FontAwesomeIcons.circleInfo)),
        ],
      );
    });
  }
}
