import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/_state/writing_bloc.dart';

class ChapterNavigationButton extends StatelessWidget {
  final int index;
  const ChapterNavigationButton({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WritingBloc, WritingState>(
        builder: (chapterContext, WritingState writingState) {
      final selectedColor = Theme.of(context).primaryColor;
      final selectedTextColor = Colors.white;
      return Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  backgroundColor: writingState.currentIndex == index
                      ? selectedColor
                      : Colors.transparent),
              onPressed: () {
                context.read<WritingBloc>().add(SwitchChapterEvent(
                    chapterToSwitchTo: index,
                    chapterToSwitchFrom: writingState.currentIndex));
              },
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text("Chapter ${index + 1}",
                      style: Theme.of(context).textTheme.labelLarge?.apply(
                          fontSizeDelta: 4,
                          color: writingState.currentIndex == index
                              ? selectedTextColor
                              : null)))));
    });
  }
}
