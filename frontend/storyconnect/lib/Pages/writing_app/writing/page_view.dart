import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/chapter/chapter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/writing/page_sliver.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class WritingPageView extends StatefulWidget {
  const WritingPageView({super.key});

  @override
  WritingPageViewState createState() => WritingPageViewState();
}

class WritingPageViewState extends State<WritingPageView> {
  final textController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (focusNode.hasFocus) {
      RawKeyboard.instance.addListener(_handleKeyEvent);
    } else {
      RawKeyboard.instance.removeListener(_handleKeyEvent);
    }
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      final isCmdPressed = event.isMetaPressed;
      final isCtrlPressed = event.isControlPressed;
      final isZPressed = event.logicalKey == LogicalKeyboardKey.keyZ;

      if ((isCmdPressed || isCtrlPressed) && isZPressed) {
        print("Undo Pressed!");
        // Implement undo logic
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: RenderPageSliver.pageWidth),
        child: BlocConsumer<ChapterBloc, ChapterBlocStruct>(
            listener: (context, state) {
          textController.text = state.chapters[state.currentIndex] ?? "";
        }, buildWhen: (previous, current) {
          return previous.currentIndex != current.currentIndex ||
              previous.loadingStruct != current.loadingStruct;
        }, builder: (context, state) {
          if (state.loadingStruct.isLoading) {
            return LoadingWidget(
              loadingStruct: state.loadingStruct,
            );
          }

          return SingleChildScrollView(
              child: Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[200]!, width: 1),
                    color: Colors.white,
                  ),
                  constraints:
                      BoxConstraints(minHeight: RenderPageSliver.pageHeight),
                  child: TextField(
                    controller: textController,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter your text here',
                    ),
                    onChanged: (value) {
                      context.read<ChapterBloc>().add(UpdateChapterEvent(
                            text: value,
                            selection: textController.selection,
                          ));
                    },
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  )));
        }));
  }
}
