import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/_state/writing_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/chapter/chapter_create_button.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/chapter/chapter_nav_button.dart';
import 'package:storyconnect/Pages/writing_app/components/side_popup_header.dart';
import 'package:storyconnect/Pages/writing_app/components/ui_state/writing_ui_bloc.dart';
import 'package:uuid/uuid.dart';

class ChapterNavigation extends StatefulWidget {
  const ChapterNavigation({super.key});

  @override
  _ChapterNavigationState createState() => _ChapterNavigationState();
}

class _ChapterNavigationState extends State<ChapterNavigation> {
  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WritingUIBloc, WritingUIState>(builder: (context, uiState) {
      return BlocBuilder<WritingBloc, WritingState>(
          buildWhen: (previous, current) =>
              previous.chapters != current.chapters ||
              previous.chapterNumToID != current.chapterNumToID ||
              previous.chapterIDToTitle != current.chapterIDToTitle ||
              previous.currentIndex != current.currentIndex,
          builder: (context, writingState) {
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
                                    Expanded(
                                        child: ListView.builder(
                                            controller: _scrollController,
                                            itemCount: writingState.chapters.length + 1,
                                            itemBuilder: (context, index) {
                                              if (index == writingState.chapters.length) {
                                                return ChapterCreateButton();
                                              }
                                              Uuid uuid = Uuid();
                                              String keyString;
                                              if (writingState.chapterNumToID.containsKey(index)) {
                                                keyString = writingState.chapterNumToID[index].toString();
                                              } else {
                                                keyString = uuid.v4();
                                              }

                                              return ChapterNavigationButton(
                                                key: Key(keyString),
                                                index: index,
                                                numOfChapters: writingState.chapters.length,
                                              );
                                            }))
                                  ],
                                ))
                            : Container())),
                crossFadeState: uiState.chapterOutlineShown ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: Duration(milliseconds: 500));
          });
    });
  }
}
