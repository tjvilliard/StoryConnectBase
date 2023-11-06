import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/_state/writing_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/ui_state/writing_ui_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/text_highlight_widget.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';
import 'package:visual_editor/visual-editor.dart';

class WritingPageView extends StatefulWidget {
  const WritingPageView({super.key});

  @override
  WritingPageViewState createState() => WritingPageViewState();
}

class WritingPageViewState extends State<WritingPageView> {
  // final textController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  EditorController editorController = EditorController();
  final EditorConfigM config = EditorConfigM();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(_handleFocusChange);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final uiBloc = context.read<WritingUIBloc>();
      uiBloc.state.textScrollController.addListener(() {
        uiBloc.add(RemoveHighlightEvent());
      });
    });
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
        constraints: BoxConstraints(maxWidth: WritingUIBloc.pageWidth),
        child:
            BlocConsumer<WritingBloc, WritingState>(listener: (context, state) {
          // if what is stored in the state is not the same format, then we need to convert it
          setState(() {
            if (state.chapters[state.currentIndex] == "" ||
                state.chapters[state.currentIndex] == null) {
              editorController = EditorController(document: DeltaDocM());
            } else {
              editorController = EditorController(
                  document: DeltaDocM.fromJson(
                      jsonDecode(state.chapters[state.currentIndex]!)));
            }
          });
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
            toReturn = Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[200]!, width: 1),
                  color: Colors.white,
                ),
                constraints:
                    BoxConstraints(minHeight: WritingUIBloc.pageHeight),
                child: TextHighlightWidget(
                    child: VisualEditor(
                  scrollController:
                      context.read<WritingUIBloc>().state.textScrollController,
                  controller: editorController,
                  focusNode: focusNode,
                  config: config,
                )));
          }
          return AnimatedSwitcher(
              duration: Duration(milliseconds: 500), child: toReturn);
        }));
  }
}
