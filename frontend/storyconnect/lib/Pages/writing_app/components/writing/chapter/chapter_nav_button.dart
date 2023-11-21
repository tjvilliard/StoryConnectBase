import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/_state/writing_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/chapter/chapter_text.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/chapter/update_chapter_dialog.dart';

class ChapterNavigationButton extends StatefulWidget {
  final int index;
  final int numOfChapters;

  const ChapterNavigationButton({
    super.key,
    required this.index,
    required this.numOfChapters,
  });

  @override
  _ChapterNavigationButtonState createState() => _ChapterNavigationButtonState();
}

class _ChapterNavigationButtonState extends State<ChapterNavigationButton> {
  bool isHovered = false;

  onDelete() {
    context.read<WritingBloc>().add(DeleteChapterEvent(chapterNum: widget.index));
  }

  onSaveTitle(String title) {
    context.read<WritingBloc>().add(UpdateChapterTitleEvent(chapterNum: widget.index, title: title));
  }

  String buildTitle(WritingState writingState) {
    String title;
    if (writingState.chapterIDToTitle[writingState.chapterNumToID[widget.index]] == null ||
        writingState.chapterIDToTitle[writingState.chapterNumToID[widget.index]]?.isEmpty == true) {
      final int naturalIndex = widget.index + 1;
      title = "Chapter $naturalIndex";
    } else {
      title = writingState.chapterIDToTitle[writingState.chapterNumToID[widget.index]]!;
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WritingBloc, WritingState>(
      builder: (chapterContext, WritingState writingState) {
        final selectedColor = Theme.of(context).primaryColor;

        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: writingState.currentIndex == widget.index ? selectedColor : Colors.transparent,
                  ),
                  onPressed: () {
                    context.read<WritingBloc>().add(SwitchChapterEvent(chapterToSwitchTo: widget.index));
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      width: 160,
                      child: ChapterTextWidget(index: widget.index),
                    ),
                  ),
                ),
                Container(
                    alignment: Alignment.centerRight,
                    child: Opacity(
                      opacity: isHovered ? 1.0 : 0.4, // High opacity when hovered, low otherwise
                      child: Padding(
                          padding: EdgeInsets.only(right: 6),
                          child: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) => UpdateChapterDialog(
                                      title: buildTitle(writingState),
                                      onDelete: onDelete,
                                      onSaveTitle: onSaveTitle,
                                      numOfChapters: widget.numOfChapters));
                            },
                          )),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}
