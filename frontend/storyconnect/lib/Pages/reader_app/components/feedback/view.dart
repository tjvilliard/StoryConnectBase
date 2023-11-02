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
        builder: (context, uiState) {
      return BlocBuilder<ChapterBloc, ChapterBlocStruct>(
          builder: (context, chapterState) {
        return BlocBuilder<FeedbackBloc, FeedbackState>(
            builder: (context, feedbackState) {
          return AnimatedCrossFade(
              alignment: Alignment.centerRight,
              firstChild: Container(),
              secondChild: Container(
                  width: 300,
                  child: Card(
                      elevation: 3,
                      child: uiState.feedbackBarShown
                          ? Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  FeedbackTypeSelector(),
                                  Container(
                                      constraints: BoxConstraints(),
                                      child: SentimentSelectorWidget()),
                                  Expanded(
                                      child: FeedbackCardListWidget(
                                          feedbackItems: feedbackState
                                                  .feedbackSet.isEmpty
                                              ? []
                                              : feedbackState
                                                  .feedbackSet.entries
                                                  .where((element) =>
                                                      element.key ==
                                                      chapterState.chapterIndex)
                                                  .first
                                                  .value)),
                                  feedbackState.selectedFeedbackType ==
                                          FeedbackType.suggestion
                                      ? SuggestionInputWidget()
                                      : CommentInputWidget()
                                ],
                              ))
                          : Container())),
              crossFadeState: uiState.feedbackBarShown
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: Duration(milliseconds: 200));
        });
      });
    });
  }
}
