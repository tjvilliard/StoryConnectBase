import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/chapter/chapter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/chapter/chapter_create_button.dart';
import 'package:storyconnect/Pages/writing_app/chapter/chapter_nav_button.dart';
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
          buildWhen: (previous, current) {
        return previous.chapters.length != current.chapters.length;
      }, builder: (chapterBlocContext, chapterState) {
        return AnimatedCrossFade(
            firstChild: Container(),
            secondChild: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).dividerColor,
                          blurRadius: 10,
                          offset: Offset(3, 3),
                          spreadRadius: 5)
                    ],
                    // border: Border.all(color: Colors.black, width: .5),
                    borderRadius: BorderRadius.circular(16)),
                padding: EdgeInsets.all(25),
                margin: EdgeInsets.all(15),
                constraints: BoxConstraints(minWidth: 300, maxWidth: 300),
                child: uiState.chapterOutlineShown
                    ? ListView.builder(
                        itemCount: chapterState.chapters.length + 1,
                        itemBuilder: (context, index) {
                          if (index == chapterState.chapters.length) {
                            return ChapterCreateButton();
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
