import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/chapter/chapter_bloc.dart';

class ChapterNavigationButton extends StatelessWidget {
  final int index;
  const ChapterNavigationButton({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChapterBloc, ChapterBlocStruct>(
        builder: (chapterContext, ChapterBlocStruct chapterState) {
      final selectedColor = Theme.of(context).primaryColor;
      final selectedTextColor = Colors.white;
      return Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  backgroundColor: chapterState.currentIndex == index
                      ? selectedColor
                      : Colors.transparent),
              onPressed: () {
                context
                    .read<ChapterBloc>()
                    .add(SwitchChapter(chapterToSwitchTo: index));
              },
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text("Chapter ${index + 1}",
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: chapterState.currentIndex == index
                              ? selectedTextColor
                              : null)))));
    });
  }
}
