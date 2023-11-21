import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/chapter/state/chapter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/state/feedback_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/page_view/page_sliver.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class ReadingPageView extends StatefulWidget {
  const ReadingPageView({super.key});

  @override
  ReadingPageViewState createState() => ReadingPageViewState();
}

class ReadingPageViewState extends State<ReadingPageView> {
  final textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _focusNode.addListener(() {
      if (kDebugMode) {
        print("[INFO]: Has Focus: ${_focusNode.hasFocus}");
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: RenderPageSliver.pageWidth),
        child: BlocConsumer<ChapterBloc, ChapterBlocStruct>(listener: (context, state) {
          textController.text = state.chapters[state.currentChapterIndex] ?? "";
        }, buildWhen: (previous, current) {
          return previous.currentChapterIndex != current.currentChapterIndex ||
              previous.loadingStruct != current.loadingStruct;
        }, builder: (context, state) {
          Widget toReturn;
          if (state.loadingStruct.isLoading) {
            toReturn = LoadingWidget(
              loadingStruct: state.loadingStruct,
            );
          } else {
            toReturn = BlocBuilder<FeedbackBloc, FeedbackState>(builder: (context, feedbackState) {
              return SingleChildScrollView(
                  child: Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[200]!, width: 1),
                        color: Colors.white,
                      ),
                      constraints: BoxConstraints(minHeight: RenderPageSliver.pageHeight),
                      child: Listener(
                        onPointerUp: (details) {
                          if (_focusNode.hasFocus) {
                            details.position;

                            int offset = textController.selection.baseOffset;
                            int offsetEnd = textController.selection.end;
                            String textSelection = textController.text
                                .substring(textController.selection.baseOffset, textController.selection.end);

                            context.read<FeedbackBloc>().add(AnnotationChangedEvent(
                                chapterBloc: context.read<ChapterBloc>(),
                                offset: offset,
                                offsetEnd: offsetEnd,
                                text: textSelection));
                          }
                        },
                        child: TextField(
                          focusNode: _focusNode,
                          decoration: null,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black, fontSize: 16),
                          controller: textController,
                          readOnly: true,
                          maxLines: null,
                          onTapOutside: (_) {},
                        ),
                      )));
            });
          }
          return AnimatedSwitcher(duration: const Duration(milliseconds: 500), child: toReturn);
        }));
  }
}
