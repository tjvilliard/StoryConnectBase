import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/_state/writing_bloc.dart';

class ChapterTextWidget extends StatelessWidget {
  final int index;

  const ChapterTextWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WritingBloc, WritingState>(
        buildWhen: (previous, current) =>
            previous.updatingChapter[index] != current.updatingChapter[index] ||
            previous.chapterIDToTitle[previous.chapterNumToID[index]] !=
                current.chapterIDToTitle[current.chapterNumToID[index]] ||
            previous.currentIndex != current.currentIndex,
        builder: (context, state) {
          const selectedTextColor = Colors.white;

          Widget toReturn;
          if (state.updatingChapter[index] == true) {
            toReturn = Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(5),
                ));
          } else {
            String title;
            if (state.chapterIDToTitle[state.chapterNumToID[index]] == null ||
                state.chapterIDToTitle[state.chapterNumToID[index]]?.isEmpty == true ||
                int.tryParse(state.chapterIDToTitle[state.chapterNumToID[index]]!) != null) {
              final int naturalIndex = index + 1;
              title = "Chapter $naturalIndex";
            } else {
              title = state.chapterIDToTitle[state.chapterNumToID[index]]!;
            }
            toReturn = Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.apply(fontSizeDelta: 4, color: state.currentIndex == index ? selectedTextColor : null),
            );
          }

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: toReturn,
          );
        });
  }
}
