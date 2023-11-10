import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/chapter/state/chapter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/components/feedback_input.dart';
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
      return BlocBuilder<FeedbackBloc, FeedbackState>(
        builder: (context, feedState) {
          return BlocBuilder<ChapterBloc, ChapterBlocStruct>(
              builder: (context, state) {
            return AnimatedCrossFade(
              crossFadeState: !uiState.feedbackBarShown
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: Duration(milliseconds: 200),
              alignment: Alignment.centerRight,
              firstChild: Container(),
              secondChild: Container(
                  width: 350,
                  child: Card(
                    elevation: 3,
                    child: uiState.feedbackBarShown
                        ? Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                      "Feedback for Chapter Index: ${BlocProvider.of<ChapterBloc>(context).state.currentChapterIndex}"),
                                  Text(
                                      "Feedback for Chapter ID: ${BlocProvider.of<ChapterBloc>(context).currentChapterId}"),
                                  FeedbackTypeSelector(),
                                  SentimentSelectorWidget(),
                                  Expanded(
                                      child: FeedbackCardListWidget(
                                          feedbackItems: [])),
                                  FeedbackInputWidget(),
                                ]))
                        : Container(),
                  )),
            );
          });
        },
      );
    });
  }
}
