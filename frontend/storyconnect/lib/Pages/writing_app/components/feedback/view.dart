import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/_state/writing_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/feedback/components/feedback_list.dart';
import 'package:storyconnect/Pages/writing_app/components/feedback/components/feedback_selector.dart';
import 'package:storyconnect/Pages/writing_app/components/feedback/components/ghost_feedback_checkbox.dart';
import 'package:storyconnect/Pages/writing_app/components/feedback/state/feedback_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/side_popup_header.dart';
import 'package:storyconnect/Pages/writing_app/components/ui_state/writing_ui_bloc.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class FeedbackWidget extends StatefulWidget {
  const FeedbackWidget({super.key});

  @override
  FeedbackWidgetState createState() => FeedbackWidgetState();
}

class FeedbackWidgetState extends State<FeedbackWidget> {
  bool firstLoaded = false;
  final suggestionListKey = GlobalKey();
  final commentsListKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WritingUIBloc, WritingUIState>(buildWhen: (previous, current) {
      final bool feedbackUIshownChanged = previous.feedbackUIshown != current.feedbackUIshown;

      return feedbackUIshownChanged;
    }, builder: (context, uiState) {
      return AnimatedCrossFade(
        firstChild: Container(),
        secondChild: uiState.feedbackUIshown
            ? BlocBuilder<FeedbackBloc, FeedbackState>(
                builder: (context, state) {
                  return Card(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 400, minWidth: 300),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SidePopupHeader(
                              title: "Comments",
                              dismiss: () => BlocProvider.of<WritingUIBloc>(context).add(const ToggleFeedbackUIEvent())),
                          const SizedBox(height: 20),
                          const Column(
                            children: [
                              FeedbackTypeSelector(),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const GhostFeedbackCheckbox(),
                          const SizedBox(
                            height: 10,
                          ),
                          BlocListener<WritingBloc, WritingState>(
                              listener: (context, writingState) {
                                final int chapterId = writingState.currentChapterId;

                                context.read<FeedbackBloc>().add(LoadChapterFeedback(chapterId));
                              },
                              child: Expanded(
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 500),
                                  child: state.loadingStruct.isLoading
                                      ? LoadingWidget(
                                          loadingStruct: state.loadingStruct) // This will show when loading.
                                      : (state.selectedFeedbackType == FeedbackType.comment
                                          ? FeedbackList(key: commentsListKey, feedbacks: state.comments)
                                          : FeedbackList(key: suggestionListKey, feedbacks: state.suggestions)),
                                ),
                              ))
                        ],
                      ),
                    ),
                  );
                },
              )
            : Container(),
        crossFadeState: uiState.feedbackUIshown ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 500),
      );
    });
  }
}
