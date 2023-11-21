import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/reader_app/components/chapter/state/chapter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/menubar/reading_menu_button.dart';
import 'package:storyconnect/Pages/reader_app/components/menubar/reading_menubar.dart';
import 'package:storyconnect/Pages/reader_app/components/ui_state/reading_ui_bloc.dart';

/// Navigates a chapter backward if the current chapter index isn't 1.
class NavigateBackwardButton extends ReadingIconButton {
  /// Navigates the current chapter backwards on pressed if the index allows it.
  const NavigateBackwardButton({super.key, required super.disableCondition});

  @override
  Widget buildButton(ButtonStyle defaultStyle) {
    return BlocBuilder<ChapterBloc, ChapterBlocStruct>(builder: (BuildContext context, ChapterBlocStruct chapterState) {
      return SizedBox(
          height: ReadingMenuBar.height,
          width: ReadingMenuBar.height,
          child: IconButton(
            style: defaultStyle,
            onPressed: chapterState.currentChapterIndex == 0
                ? null
                : () {
                    context
                        .read<ChapterBloc>()
                        .add(DecrementChapterEvent(currentChapter: chapterState.currentChapterIndex));
                  },
            icon: const Icon(FontAwesomeIcons.arrowLeft),
          ));
    });
  }
}

/// Navigates a chapter forward if the current chapter index won't
/// exceed the chapter length.
class NavigateForwardButton extends ReadingIconButton {
  /// Navigates the current chapter forward on pressed if the index allows it.
  const NavigateForwardButton({super.key, required super.disableCondition});

  @override
  Widget buildButton(ButtonStyle defaultStyle) {
    return BlocBuilder<ChapterBloc, ChapterBlocStruct>(builder: (BuildContext context, ChapterBlocStruct chapterState) {
      return SizedBox(
          height: ReadingMenuBar.height,
          width: ReadingMenuBar.height,
          child: IconButton(
            style: defaultStyle,
            icon: const Icon(FontAwesomeIcons.arrowRight),
            onPressed: super.disableCondition
                ? null
                : () {
                    context
                        .read<ChapterBloc>()
                        .add(IncrementChapterEvent(currentChapter: chapterState.currentChapterIndex));
                  },
          ));
    });
  }
}

///
class ChapterNavigationBarButton extends ReadingIconButton {
  ///
  const ChapterNavigationBarButton({super.key, required super.disableCondition});

  @override
  Widget buildButton(ButtonStyle defaultStyle) {
    return BlocBuilder<ReadingUIBloc, ReadingUIState>(builder: (BuildContext context, ReadingUIState uiState) {
      return BlocBuilder<ChapterBloc, ChapterBlocStruct>(
        builder: (BuildContext context, ChapterBlocStruct chapterState) {
          return SizedBox(
              height: ReadingMenuBar.height,
              child: TextButton.icon(
                icon: const Icon(FontAwesomeIcons.list),
                label: Text("Chapter ${chapterState.currentChapterIndex + 1}" "/${chapterState.chapters.length}"),
                onPressed: () {
                  context.read<ReadingUIBloc>().add(ToggleChapterOutlineEvent());
                },
              ));
        },
      );
    });
  }
}

///
class AuthorPageButton extends ReadingIconButton {
  ///
  const AuthorPageButton({super.key, required super.disableCondition});

  @override
  Widget buildButton(ButtonStyle defaultStyle) {
    return SizedBox(
      height: ReadingMenuBar.height,
      width: ReadingMenuBar.height,
      child: IconButton(
        icon: const Icon(FontAwesomeIcons.person),
        onPressed: super.disableCondition ? null : () {},
      ),
    );
  }
}

///
class ChapterFeedbackButton extends ReadingIconButton {
  ///
  const ChapterFeedbackButton({super.key, required super.disableCondition});

  @override
  Widget buildButton(ButtonStyle defaultStyle) {
    return BlocBuilder<ReadingUIBloc, ReadingUIState>(
      builder: (BuildContext context, ReadingUIState uiState) {
        return SizedBox(
          height: ReadingMenuBar.height,
          child: TextButton.icon(
            icon: const Icon(FontAwesomeIcons.comment),
            label: const Text("Feedback"),
            onPressed: super.disableCondition
                ? null
                : () {
                    BlocProvider.of<ReadingUIBloc>(context).add(ToggleFeedbackBarEvent());
                  },
          ),
        );
      },
    );
  }
}
