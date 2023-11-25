import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/reader_app/components/menubar/view.dart';
import 'package:storyconnect/Pages/reader_app/components/reading/state/reading_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/ui_state/reading_ui_bloc.dart';

class PreviousChapterButton extends StatelessWidget {
  const PreviousChapterButton({super.key});

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

class NextChapterButton extends StatelessWidget {
  const NextChapterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadingBloc, ReadingState>(
        builder: (BuildContext context, ReadingState readingState) {
      return SizedBox(
          height: ReadingMenuBar.height,
          width: ReadingMenuBar.height,
          child: IconButton(
            icon: const Icon(FontAwesomeIcons.arrowRight),
            onPressed:
                readingState.currentIndex == readingState.chapters.length - 1
                    ? null
                    : () {
                        context.read<ReadingBloc>().add(IncrementChapterEvent(
                            currentChapter: readingState.currentIndex));
                      },
          ));
    });
  }
}

class ChapterNavigationBarButton extends StatelessWidget {
  const ChapterNavigationBarButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: ReadingMenuBar.height,
        child: TextButton.icon(
          icon: const Icon(FontAwesomeIcons.list),
          label: BlocBuilder<ReadingBloc, ReadingState>(
              builder: (BuildContext context, ReadingState state) {
            return Text("Chapter ${state.currentIndex + 1}"
                "/${state.chapters.length}");
          }),
          onPressed: () {
            context.read<ReadingUIBloc>().add(ToggleChapterOutlineEvent());
          },
        ));
  }
}

class AuthorPageButton extends StatelessWidget {
  const AuthorPageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ReadingMenuBar.height,
      width: ReadingMenuBar.height,
      child: IconButton(
        style: Theme.of(context).textButtonTheme.style,
        icon: const Icon(Icons.person),
        onPressed: () {},
      ),
    );
  }
}

class ToggleChapterFeedback extends StatelessWidget {
  const ToggleChapterFeedback({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: ReadingMenuBar.height,
        child: TextButton.icon(
          icon: const Icon(FontAwesomeIcons.comment),
          label: const Text("Feedback"),
          onPressed: () {
            BlocProvider.of<ReadingUIBloc>(context)
                .add(ToggleFeedbackBarEvent());
          },
        ));
  }
}
