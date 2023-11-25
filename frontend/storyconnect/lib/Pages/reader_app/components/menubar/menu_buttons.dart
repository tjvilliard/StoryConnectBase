import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/reader_app/components/menubar/view.dart';
import 'package:storyconnect/Pages/reader_app/components/reading/state/reading_bloc.dart';

class NavigateBackwardButton extends StatelessWidget {
  const NavigateBackwardButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadingBloc, ReadingState>(
        builder: (BuildContext context, ReadingState readingState) {
      return SizedBox(
          height: ReadingMenuBar.height,
          width: ReadingMenuBar.height,
          child: IconButton(
            onPressed: readingState.currentIndex == 0
                ? null
                : () {
                    context.read<ReadingBloc>().add(DecrementChapterEvent(
                        currentChapter: readingState.currentIndex));
                  },
            icon: const Icon(FontAwesomeIcons.arrowLeft),
          ));
    });
  }
}
