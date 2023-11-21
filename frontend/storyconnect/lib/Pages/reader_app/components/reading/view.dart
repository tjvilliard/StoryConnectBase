import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/reading/state/reading_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/ui_state/reading_ui_bloc.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';
import 'package:visual_editor/visual-editor.dart';

class ReadingPageView extends StatefulWidget {
  const ReadingPageView({super.key});

  @override
  ReadingPageViewState createState() => ReadingPageViewState();
}

class ReadingPageViewState extends State<ReadingPageView> {
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(
          maxWidth: 800.0,
        ),
        child: BlocBuilder<ReadingBloc, ReadingState>(
          buildWhen: (previous, current) {
            return previous.currentIndex != current.currentIndex ||
                previous.loadingStruct != current.loadingStruct;
          },
          builder: (context, state) {
            Widget toReturn;
            if (state.loadingStruct.isLoading) {
              toReturn = LoadingWidget(loadingStruct: state.loadingStruct);
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
                  constraints:
                      BoxConstraints(minHeight: ReadingUIBloc.pageHeight),
                  child: VisualEditor(
                    scrollController: context
                        .read<ReadingUIBloc>()
                        .state
                        .textScrollController,
                    controller:
                        context.read<ReadingUIBloc>().state.editorController,
                    focusNode: focusNode,
                    config: state.config,
                  ));
            }
            return AnimatedSwitcher(
                duration: const Duration(milliseconds: 500), child: toReturn);
          },
        ));
  }
}
