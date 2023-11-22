import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/components/feedback_input.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/components/feedback_panel.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/components/feedback_sentiment_selector.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/components/feedback_type_selector.dart';
import 'package:storyconnect/Pages/reader_app/components/reading/state/reading_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/ui_state/reading_ui_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/state/feedback_bloc.dart';

class FeedbackWidget extends StatefulWidget {
  const FeedbackWidget({super.key});

  @override
  FeedbackWidgetState createState() => FeedbackWidgetState();
}

class FeedbackWidgetState extends State<FeedbackWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadingUIBloc, ReadingUIState>(
        builder: (context, uiState) {
      return BlocBuilder<FeedbackBloc, FeedbackState>(
        builder: (context, feedState) {
          return BlocBuilder<ReadingBloc, ReadingState>(
              builder: (context, state) {
            return AnimatedCrossFade(
              crossFadeState: !uiState.feedbackBarShown
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 500),
              alignment: Alignment.centerRight,
              firstChild: Container(),
              secondChild: SizedBox(
                  width: 350,
                  child: Card(
                    elevation: 3,
                    child: uiState.feedbackBarShown
                        ? const Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
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
