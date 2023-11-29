import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Models/text_annotation/feedback.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/_state/writing_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/ui_state/writing_ui_bloc.dart';

class NavigateToFeedbackButton extends StatelessWidget {
  final WriterFeedback feedback;

  const NavigateToFeedbackButton({super.key, required this.feedback});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 25.0,
        width: 30.0,
        child: IconButton.filled(
          padding: const EdgeInsets.all(0),
          onPressed: () => context.read<WritingUIBloc>().add(HighlightEvent(
              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black, fontSize: 16),
              selection: feedback.selection,
              chapterText: context.read<WritingBloc>().state.currentChapterText)),
          icon: const Icon(FontAwesomeIcons.arrowRight, size: 15),
        ));
  }
}
