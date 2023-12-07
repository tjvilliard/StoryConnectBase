import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/components/feedback_input.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/components/feedback_list.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/components/feedback_sentiment_selector.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/components/feedback_selector.dart';
import 'package:storyconnect/Pages/reader_app/components/panel_header.dart';
import 'package:storyconnect/Pages/reader_app/components/reading/state/reading_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/ui_state/reading_ui_bloc.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/state/feedback_bloc.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class FeedbackWidget extends StatefulWidget {
  const FeedbackWidget({super.key});

  @override
  FeedbackWidgetState createState() => FeedbackWidgetState();
}

class FeedbackWidgetState extends State<FeedbackWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadingUIBloc, ReadingUIState>(
        buildWhen: (previous, current) {
      final bool feedbackUIshownChanged =
          previous.feedbackBarShown != current.feedbackBarShown;

      return feedbackUIshownChanged;
    }, builder: (context, readingUIstate) {
      return AnimatedCrossFade(
          crossFadeState: !readingUIstate.feedbackBarShown
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 500),
          alignment: Alignment.centerRight,
          firstChild: Container(),
          secondChild: readingUIstate.feedbackBarShown
              ? BlocBuilder<FeedbackBloc, FeedbackState>(
                  builder: (context, FeedbackState feedbackState) {
                    return SizedBox(
                        width: 350,
                        child: Card(
                          elevation: 3,
                          child: readingUIstate.feedbackBarShown
                              ? Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        SidePopupHeader(
                                            title: "Comments",
                                            dismiss: () => BlocProvider.of<
                                                    ReadingUIBloc>(context)
                                                .add(ToggleFeedbackBarEvent())),
                                        const SizedBox(height: 20),
                                        const FeedbackTypeSelector(),
                                        const SentimentSelectorWidget(),
                                        BlocListener<ReadingBloc, ReadingState>(
                                            listener: (context,
                                                ReadingState readingState) {
                                              final int chapterId =
                                                  readingState.currentChapterId;
                                              context.read<FeedbackBloc>().add(
                                                  LoadChapterFeedbackEvent(
                                                      chapterId: chapterId));
                                            },
                                            child: Expanded(
                                                child: AnimatedSwitcher(
                                                    duration: const Duration(
                                                        milliseconds: 500),
                                                    child: feedbackState
                                                            .loadingStruct
                                                            .isLoading
                                                        ? LoadingWidget(
                                                            loadingStruct:
                                                                feedbackState
                                                                    .loadingStruct)
                                                        : (feedbackState
                                                                    .selectedFeedbackType ==
                                                                FeedbackType
                                                                    .suggestion
                                                            ? FeedbackList(
                                                                feedbackItems:
                                                                    feedbackState
                                                                        .suggestions)
                                                            : FeedbackList(
                                                                feedbackItems:
                                                                    feedbackState
                                                                        .comments))))),
                                        const FeedbackInputWidget(),
                                      ]))
                              : Container(),
                        ));
                  },
                )
              : const SizedBox.shrink());
    });
  }
}
