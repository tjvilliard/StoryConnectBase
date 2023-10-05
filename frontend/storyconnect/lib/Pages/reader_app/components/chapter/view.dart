import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/chapter/chapter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/chapter/chapter_nav_button.dart';
import 'package:storyconnect/Pages/reader_app/components/side_popup_header.dart';
import 'package:storyconnect/Pages/reader_app/components/ui_state/reading_ui_bloc.dart';

/// The Widget for the Reading View's Chapter Navigation.
class ChapterNavigation extends StatefulWidget {
  @override
  _ChapterNavigationState createState() => _ChapterNavigationState();
}

/// The State for the Reading View's Chapter Navigation.
class _ChapterNavigationState extends State<ChapterNavigation> {
  /// The Scroll Controller for the chapter navigation widget.
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadingUIBloc, ReadingUIState>(
        builder: (context, uiState) {
      return BlocBuilder<ChapterBloc, ChapterBlocStruct>(
          builder: (context, chapterState) {
        return AnimatedCrossFade(
            firstChild: Container(),
            secondChild: Container(
                width: 250,
                child: Card(
                    elevation: 3,
                    child: uiState.chapterOutlineShown
                        ? Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SidePopupHeader(
                                      title: "Chapter Nav",
                                      dismiss: () => BlocProvider.of<
                                              ReadingUIBloc>(context)
                                          .add(ToggleChapterOutlineEvent())),
                                  SizedBox(height: 20),
                                  Expanded(
                                      child: ListView.builder(
                                          controller: this._scrollController,
                                          itemCount:
                                              chapterState.chapters.length,
                                          itemBuilder: (context, index) {
                                            return ChapterNavButton(
                                                index: index);
                                          }))
                                ]))
                        : Container())),
            crossFadeState: uiState.chapterOutlineShown
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 200));
      });
    });
  }
}
