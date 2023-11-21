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

class WritingPageViewState extends State<WritingPageView> {
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final uiBloc = context.read<WritingUIBloc>();
      uiBloc.state.textScrollController.addListener(() {
        uiBloc.add(const RemoveHighlightEvent());
      });
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (focusNode.canRequestFocus && !focusNode.hasFocus) {
          focusNode.requestFocus();
        }
      },
      child: Container(
        constraints: BoxConstraints(
          maxWidth: WritingUIBloc.pageWidth,
        ),
        child: BlocBuilder<WritingBloc, WritingState>(buildWhen: (previous, current) {
          return previous.currentIndex != current.currentIndex || previous.loadingStruct != current.loadingStruct;
        }, builder: (context, state) {
          Widget toReturn;
          if (state.loadingStruct.isLoading) {
            toReturn = LoadingWidget(
              loadingStruct: state.loadingStruct,
            );
          } else {
            toReturn = Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border.all(color: Colors.grey[200]!, width: 1),
                  color: Colors.white,
                ),
                constraints: BoxConstraints(minHeight: WritingUIBloc.pageHeight),
                child: TextHighlightWidget(
                    child: VisualEditor(
                  scrollController: context.read<WritingUIBloc>().state.textScrollController,
                  controller: context.read<WritingUIBloc>().state.editorController,
                  focusNode: focusNode,
                  config: state.config,
                )));
          }
          return AnimatedSwitcher(duration: const Duration(milliseconds: 500), child: toReturn);
        }),
      ),
    );
  }
}
