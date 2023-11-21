import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/_state/writing_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/chapter/chapter_create_button.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/chapter/chapter_nav_button.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';
import 'package:uuid/uuid.dart';

class ChapterNavigationList extends StatelessWidget {
  const ChapterNavigationList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WritingBloc, WritingState>(
        buildWhen: (previous, current) =>
            previous.chapters != current.chapters ||
            previous.chapterNumToID != current.chapterNumToID ||
            previous.chapterIDToTitle != current.chapterIDToTitle ||
            previous.isDeletingAChapter != current.isDeletingAChapter ||
            previous.currentIndex != current.currentIndex,
        builder: (context, writingState) {
          Widget toReturn;
          if (writingState.isDeletingAChapter) {
            toReturn = Column(
              children: [LoadingWidget(loadingStruct: LoadingStruct.message("Deleting Chapter"))],
            );
          } else {
            return ListView.builder(
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
                });
          }
          return AnimatedSwitcher(duration: Duration(milliseconds: 300), child: toReturn);
        });
  }
}
