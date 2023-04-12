import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/chapter/chapter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/chapter/chapter_nav_button.dart';
import 'package:storyconnect/Pages/writing_app/writing/page_bloc.dart';
import 'package:storyconnect/Pages/writing_app/writing_ui_bloc.dart';

class ChapterNavigation extends StatelessWidget {
  const ChapterNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WritingUIBloc, WritingUIStatus>(
        buildWhen: (previous, current) {
      return previous.chapterOutlineShown != current.chapterOutlineShown;
    }, builder: (context, uiState) {
      return BlocBuilder<ChapterBloc, ChapterBlocStruct>(
          builder: (chapterBlocContext, chapterState) {
        return AnimatedCrossFade(
            firstChild: Container(),
            secondChild: Container(
                color: Colors.white,
                padding: EdgeInsets.all(25),
                constraints: BoxConstraints(minWidth: 150, maxWidth: 300),
                child: uiState.chapterOutlineShown
                    ? ListView.builder(
                        itemCount: chapterState.chapters.length + 1,
                        itemBuilder: (context, index) {
                          if (index == chapterState.chapters.length) {
                            return OutlinedButton(
                                onPressed: () => context
                                    .read<ChapterBloc>()
                                    .add(AddChapter(
                                      pageBloc: context.read<PageBloc>(),
                                      callerIndex: chapterState.currentIndex,
                                      pages: context.read<PageBloc>().state,
                                    )),
                                child: Text("Add Chapter"));
                          }
                          return ChapterNavigationButton(index: index);
                        })
                    : Container()),
            crossFadeState: uiState.chapterOutlineShown
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 200));
      });
    });
  }
}
