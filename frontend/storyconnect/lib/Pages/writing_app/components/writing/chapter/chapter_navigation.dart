import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:storyconnect/Pages/writing_app/components/side_popup_header.dart';
import 'package:storyconnect/Pages/writing_app/components/ui_state/writing_ui_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/chapter/chapter_navigation_list.dart';

class ChapterNavigation extends StatelessWidget {
  const ChapterNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WritingUIBloc, WritingUIState>(
        buildWhen: (previous, current) => previous.chapterOutlineShown != current.chapterOutlineShown,
        builder: (context, uiState) {
          return AnimatedCrossFade(
              firstChild: Container(),
              secondChild: Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.all(8),
                  width: 300,
                  child: Card(
                      elevation: 3,
                      child: uiState.chapterOutlineShown
                          ? Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SidePopupHeader(
                                      title: "Chapter Nav",
                                      dismiss: () =>
                                          BlocProvider.of<WritingUIBloc>(context).add(ToggleChapterOutlineEvent())),
                                  SizedBox(height: 20),
                                  Expanded(child: ChapterNavigationList())
                                ],
                              ))
                          : Container())),
              crossFadeState: uiState.chapterOutlineShown ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: Duration(milliseconds: 500));
        });
  }
}
