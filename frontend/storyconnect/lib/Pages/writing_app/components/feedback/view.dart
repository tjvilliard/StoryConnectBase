import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/chapter/chapter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/feedback/components/feedback_list.dart';
import 'package:storyconnect/Pages/writing_app/components/feedback/components/feedback_selector.dart';
import 'package:storyconnect/Pages/writing_app/components/feedback/components/ghost_feedback_checkbox.dart';
import 'package:storyconnect/Pages/writing_app/components/feedback/state/feedback_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/side_popup_header.dart';
import 'package:storyconnect/Pages/writing_app/components/ui_state/writing_ui_bloc.dart';

class FeedbackWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ChapterBloc, ChapterBlocStruct>(
        listener: (context, chapterState) {
          context
              .read<FeedbackBloc>()
              .add(LoadChapterFeedback(chapterState.currentIndex));
        },
        child: BlocBuilder<WritingUIBloc, WritingUIState>(
            buildWhen: (previous, current) {
          final bool feedbackUIshownChanged =
              previous.feedbackUIshown != current.feedbackUIshown;

          return feedbackUIshownChanged;
        }, builder: (context, uiState) {
          return AnimatedCrossFade(
            firstChild: Container(),
            secondChild: uiState.feedbackUIshown
                ? BlocBuilder<FeedbackBloc, FeedbackState>(
                    builder: (context, state) {
                      return Card(
                        child: Container(
                          constraints:
                              BoxConstraints(maxWidth: 400, minWidth: 300),
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SidePopupHeader(
                                  title: "Comments",
                                  dismiss: () =>
                                      BlocProvider.of<WritingUIBloc>(context)
                                          .add(ToggleFeedbackUIEvent())),
                              SizedBox(height: 20),
                              Column(
                                children: [
                                  FeedbackTypeSelector(),
                                ],
                              ),
                              SizedBox(height: 10),
                              GhostFeedbackCheckbox(),
                              SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: AnimatedSwitcher(
                                  duration: Duration(milliseconds: 200),
                                  child: state.selectedFeedbackType ==
                                          FeedbackType.comment
                                      ? FeedbackList(
                                          key: UniqueKey(),
                                          feedbacks: state.suggestions)
                                      : FeedbackList(
                                          key: UniqueKey(),
                                          feedbacks: state.comments),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Container(),
            crossFadeState: uiState.feedbackUIshown
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 200),
          );
        }));
  }
}
