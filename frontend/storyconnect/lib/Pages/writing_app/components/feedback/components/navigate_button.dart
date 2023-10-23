import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:storyconnect/Models/text_annotation/feedback.dart';
import 'package:storyconnect/Pages/writing_app/components/chapter/chapter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/ui_state/writing_ui_bloc.dart';

class NavigateToFeedbackButton extends StatelessWidget {
  final WriterFeedback feedback;

  NavigateToFeedbackButton({Key? key, required this.feedback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 25.0,
        width: 30.0,
        child: IconButton.filled(
          padding: EdgeInsets.all(0),
          onPressed: () => context.read<WritingUIBloc>().add(HighlightEvent(
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.black, fontSize: 16),
              selection: feedback.selection,
              chapterText:
                  context.read<ChapterBloc>().state.currentChapterText)),
          icon: Icon(FontAwesomeIcons.arrowRight, size: 15),
        ));
  }
}
