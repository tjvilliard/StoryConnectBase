import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/chapter/chapter_bloc.dart';

/// Button for navigating chapters through the reading view.
class ChapterNavButton extends StatelessWidget {
  final int index;
  const ChapterNavButton({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChapterBloc, ChapterBlocStruct>(
        builder: (BuildContext chapterContext, ChapterBlocStruct chapterState) {
      final selectedColor = Theme.of(context).primaryColor;
      final selectedTextColor = Colors.white;
      return Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                backgroundColor: chapterState.chapterIndex == index
                    ? selectedColor
                    : Colors.transparent),
            onPressed: () {
              context.read<ChapterBloc>().add(SwitchChapter(
                  chapterToSwitchTo: index,
                  chapterToSwitchFrom: chapterState.chapterIndex));
            },
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text("Chapter ${index}",
                    style: Theme.of(context).textTheme.labelLarge?.apply(
                        fontSizeDelta: 4,
                        color: chapterState.chapterIndex == index
                            ? selectedTextColor
                            : null))),
          ));
    });
  }
}
