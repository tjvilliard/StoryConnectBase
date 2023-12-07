import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/reading/state/reading_bloc.dart';

/// Button for navigating chapters through the reading view.
class ChapterNavButton extends StatelessWidget {
  final int index;
  const ChapterNavButton({
    super.key,
    required this.index,
  });

  String buildTitle(ReadingState readingState) {
    String title;
    if (readingState.chapterIDToTitle[readingState.chapterNumToID[index]] ==
            null ||
        readingState.chapterIDToTitle[readingState.chapterNumToID[index]]
                ?.isEmpty ==
            true) {
      final int naturalIndex = index + 1;
      title = "Chapter $naturalIndex";
    } else {
      title =
          readingState.chapterIDToTitle[readingState.chapterNumToID[index]]!;
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadingBloc, ReadingState>(
        builder: (BuildContext context, ReadingState state) {
      final selectedColor = Theme.of(context).primaryColor;
      const selectedTextColor = Colors.white;
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                backgroundColor: state.currentIndex == index
                    ? selectedColor
                    : Colors.transparent),
            onPressed: () {
              context.read<ReadingBloc>().add(SwitchChapterEvent(
                  chapterToSwitchTo: index,
                  chapterToSwitchFrom: state.currentIndex));
            },
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(buildTitle(state),
                    style: Theme.of(context).textTheme.labelLarge?.apply(
                        fontSizeDelta: 4,
                        color: state.currentIndex == index
                            ? selectedTextColor
                            : null))),
          ));
    });
  }
}
