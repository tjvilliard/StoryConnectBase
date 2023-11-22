import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/state/feedback_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/reading/state/reading_bloc.dart';

/// Button for navigating chapters through the reading view.
class ChapterNavButton extends StatelessWidget {
  final int index;
  const ChapterNavButton({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedbackBloc, FeedbackState>(
        builder: (BuildContext context, FeedbackState feedbackState) {
      return BlocBuilder<ReadingBloc, ReadingState>(
          builder: (BuildContext context, ReadingState chapterState) {
        final selectedColor = Theme.of(context).primaryColor;
        const selectedTextColor = Colors.white;
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  backgroundColor: chapterState.currentIndex == index
                      ? selectedColor
                      : Colors.transparent),
              onPressed: () {
                context.read<ReadingBloc>().add(SwitchChapterEvent(
                    chapterToSwitchTo: index,
                    chapterToSwitchFrom: chapterState.currentIndex));
              },
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text("Chapter ${index + 1}",
                      style: Theme.of(context).textTheme.labelLarge?.apply(
                          fontSizeDelta: 4,
                          color: chapterState.currentIndex == index
                              ? selectedTextColor
                              : null))),
            ));
      });
    });
  }
}
