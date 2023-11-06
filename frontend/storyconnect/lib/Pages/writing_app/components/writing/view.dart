import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/_state/writing_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/ui_state/writing_ui_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/_components/text_highlight_widget.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';
import 'package:visual_editor/visual-editor.dart';

class WritingPageView extends StatefulWidget {
  const WritingPageView({super.key});

  @override
  WritingPageViewState createState() => WritingPageViewState();
}

class WritingPageViewState extends State<WritingPageView>
    with AutomaticKeepAliveClientMixin {
  final FocusNode focusNode = FocusNode();
  final EditorController editorController = EditorController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final uiBloc = context.read<WritingUIBloc>();
      final WritingBloc writingBloc = context.read<WritingBloc>();
      writingBloc
          .add(SetEditorControllerCallbackEvent(callback: getEditorController));
      uiBloc.state.textScrollController.addListener(() {
        uiBloc.add(RemoveHighlightEvent());
      });
    });
  }

  @override
  void dispose() {
    editorController.close();
    focusNode.dispose();
    super.dispose();
  }

  EditorController getEditorController() {
    return editorController;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        constraints: BoxConstraints(maxWidth: WritingUIBloc.pageWidth),
        child: BlocBuilder<WritingBloc, WritingState>(
            buildWhen: (previous, current) {
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
                  config: state.config,
                )));
          }
          return AnimatedSwitcher(
              duration: Duration(milliseconds: 500), child: toReturn);
        }));
  }

  @override
  bool get wantKeepAlive {
    if (editorController.isClosed()) {
      return false;
    } else {
      return true;
    }
  }
}
