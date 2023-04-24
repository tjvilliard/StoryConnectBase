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
    final selectedColor = Theme.of(context).primaryColor;
    final selectedTextColor = Colors.white;
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: BlocBuilder<PageBloc, PageBlocStruct>(
          builder: (BuildContext context, PageBlocStruct pageBlocStruct) {
            return OutlinedButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor:
                        context.read<ChapterBloc>().state.currentIndex == index
                            ? selectedColor
                            : Colors.transparent),
                onPressed: () {
                  context.read<ChapterBloc>().add(SwitchChapter(
                      pageBloc: context.read<PageBloc>(),
                      callerIndex: index,
                      pages: pageBlocStruct.pages,
                      chapterToSwitchFrom:
                          context.read<ChapterBloc>().state.currentIndex));
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text("Chapter ${index + 1}",
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color:
                              context.read<ChapterBloc>().state.currentIndex ==
                                      index
                                  ? selectedTextColor
                                  : null)),
                ));
          },
        ));
  }
}