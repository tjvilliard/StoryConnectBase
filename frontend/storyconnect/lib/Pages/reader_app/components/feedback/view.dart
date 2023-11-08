import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/chapter/state/chapter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/components/feedback_input/comment_input.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/components/feedback_input/suggestion_input.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/components/feedback_panel.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/components/feedback_sentiment_selector.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/components/feedback_type_selector.dart';
import 'package:storyconnect/Pages/reader_app/components/ui_state/reading_ui_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/state/feedback_bloc.dart';

class FeedbackWidget extends StatefulWidget {
  @override
  _FeedbackWidgetState createState() => _FeedbackWidgetState();
}

class _FeedbackWidgetState extends State<FeedbackWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadingUIBloc, ReadingUIState>(
        buildWhen: (previous, current) {
      final bool feedbackBarShownChanged =
          previous.feedbackBarShown != current.feedbackBarShown;

      return feedbackBarShownChanged;
    }, builder: (context, uiState) {
      return AnimatedCrossFade(
        firstChild: SizedBox.shrink(),
        secondChild: uiState.feedbackBarShown
            ? SizedBox.shrink()
            : BlocBuilder<FeedbackBloc, FeedbackState>(
                builder: (context, feedbackState) {
                return Card(
                    child: Container(
                        constraints:
                            BoxConstraints(maxWidth: 400, minWidth: 300),
                        padding: EdgeInsets.all(16),
                        child: Column(children: [
                          FeedbackTypeSelector(),
                          SentimentSelectorWidget(),
                          Container(),
                          Expanded(
                              child:
                                  BlocListener<ChapterBloc, ChapterBlocStruct>(
                            listener: (context, chapterState) {
                              int id = context
                                  .read<ChapterBloc>()
                                  .chapterNumToID[chapterState.chapterIndex]!;
                              print(id);
                            },
                            child: FeedbackCardListWidget(
                              feedbackItems: [],
                            ),
                          )),
                          feedbackState.selectedFeedbackType ==
                                  FeedbackType.suggestion
                              ? SuggestionInputWidget()
                              : CommentInputWidget()
                        ])));
              }),
        crossFadeState: uiState.feedbackBarShown
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        duration: Duration(milliseconds: 200),
      );
    });
  }
}
