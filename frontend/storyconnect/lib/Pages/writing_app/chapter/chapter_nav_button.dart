import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/chapter/chapter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/writing/page_bloc.dart';

class ChapterNavigationButton extends StatelessWidget {
  final int index;
  const ChapterNavigationButton({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChapterBloc, ChapterBlocStruct>(
        buildWhen: (previous, current) {
      return previous.currentIndex == index || current.currentIndex == index;
    }, builder: (chapterContext, ChapterBlocStruct chapterState) {
      final selectedColor = Theme.of(context).primaryColor;
      final selectedTextColor = Colors.white;
      return Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: BlocBuilder<PageBloc, Map<int, String>>(
            builder: (BuildContext context, pages) {
              return OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: chapterState.currentIndex == index
                          ? selectedColor
                          : Colors.transparent),
                  onPressed: () {
                    context.read<ChapterBloc>().add(SwitchChapter(
                        pageBloc: context.read<PageBloc>(),
                        callerIndex: index,
                        pages: pages,
                        chapterToSwitchFrom: chapterState.currentIndex));
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text("Chapter ${index + 1}",
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(
                                color: chapterState.currentIndex == index
                                    ? selectedTextColor
                                    : null)),
                  ));
            },
          ));
    });
  }
}
