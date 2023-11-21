import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/chapter/state/chapter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/chapter/chapter_nav_button.dart';
import 'package:storyconnect/Pages/reader_app/components/panel_header.dart';
import 'package:storyconnect/Pages/reader_app/components/ui_state/reading_ui_bloc.dart';

/// The Widget for the Reading View's Chapter Navigation.
class ChapterNavigation extends StatefulWidget {
  const ChapterNavigation({super.key});

  @override
  ChapterNavigationState createState() => ChapterNavigationState();
}

/// The State for the Reading View's Chapter Navigation.
class ChapterNavigationState extends State<ChapterNavigation> {
  /// The Scroll Controller for the chapter navigation widget.
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadingUIBloc, ReadingUIState>(builder: (BuildContext context, ReadingUIState uiState) {
      return BlocBuilder<ChapterBloc, ChapterBlocStruct>(
          builder: (BuildContext context, ChapterBlocStruct chapterState) {
        return AnimatedCrossFade(
            alignment: Alignment.centerLeft,
            firstChild: Container(),
            secondChild: SizedBox(
                width: 250,
                child: Card(
                    elevation: 3,
                    child: uiState.chapterOutlineShown
                        ? Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                              SidePopupHeader(
                                  title: "Chapter Nav",
                                  dismiss: () =>
                                      BlocProvider.of<ReadingUIBloc>(context).add(ToggleChapterOutlineEvent())),
                              const SizedBox(height: 20),
                              Expanded(
                                  child: ListView.builder(
                                      controller: _scrollController,
                                      itemCount: chapterState.chapters.length,
                                      itemBuilder: (context, index) {
                                        return ChapterNavButton(index: index);
                                      }))
                            ]))
                        : Container())),
            crossFadeState: uiState.chapterOutlineShown ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 500));
      });
    });
  }
}
