import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/chapter/state/chapter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/state/feedback_bloc.dart';

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
      return BlocBuilder<ChapterBloc, ChapterBlocStruct>(
          builder: (BuildContext context, ChapterBlocStruct chapterState) {
        final selectedColor = Theme.of(context).primaryColor;
        final selectedTextColor = Colors.white;
        return Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  backgroundColor: chapterState.currentChapterIndex == index
                      ? selectedColor
                      : Colors.transparent),
              onPressed: () {
                context.read<ChapterBloc>().add(SwitchChapter(
                    chapterToSwitchTo: index,
                    chapterToSwitchFrom: chapterState.currentChapterIndex));
                context.read<FeedbackBloc>().add(LoadChapterFeedbackEvent(
                    chapterBloc: context.read<ChapterBloc>()));
              },
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text("Chapter ${index + 1}",
                      style: Theme.of(context).textTheme.labelLarge?.apply(
                          fontSizeDelta: 4,
                          color: chapterState.currentChapterIndex == index
                              ? selectedTextColor
                              : null))),
            ));
      });
    });
  }
}
