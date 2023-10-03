import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/chapter/chapter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/page_sliver.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class ReadingPageView extends StatefulWidget {
  const ReadingPageView({super.key});

  @override
  ReadingPageViewState createState() => ReadingPageViewState();
}

class ReadingPageViewState extends State<ReadingPageView> {
  final textController = TextEditingController();
  //final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    //focusNode.addListener(_handleFocusChange);
  }

/*
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
  */

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
          Widget toReturn;
          if (state.loadingStruct.isLoading) {
            toReturn = LoadingWidget(
              loadingStruct: state.loadingStruct,
            );
          } else {
            toReturn = SingleChildScrollView(
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
                      readOnly: true,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.black, fontSize: 16),
                      controller: textController,
                      //focusNode: focusNode,
                      /*
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
                      */
                    )));
          }
          return AnimatedSwitcher(
              duration: Duration(milliseconds: 500), child: toReturn);
        }));
  }
}
