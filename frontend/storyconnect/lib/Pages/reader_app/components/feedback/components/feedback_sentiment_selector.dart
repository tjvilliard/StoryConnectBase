import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Constants/feedback_sentiment.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/state/feedback_bloc.dart';

class SentimentSelectorWidget extends StatelessWidget {
  const SentimentSelectorWidget({Key? key}) : super(key: key);

  static const double radioScale = 0.75;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedbackBloc, FeedbackState>(
        builder: (BuildContext context, FeedbackState feedbackState) {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Column(
          children: [
            Transform.scale(
                scale: radioScale,
                child: Radio.adaptive(
                    value: FeedbackSentiment.bad,
                    groupValue: feedbackState.serializer.sentiment,
                    onChanged: (FeedbackSentiment? sentiment) {
                      context.read<FeedbackBloc>().add(SentimentChangedEvent(
                          sentiment: FeedbackSentiment.bad));
                    })),
            Text(
              FeedbackSentiment.bad.description,
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
        Column(
          children: [
            Transform.scale(
                scale: radioScale,
                child: Radio.adaptive(
                    value: FeedbackSentiment.mediocre,
                    groupValue: feedbackState.serializer.sentiment,
                    onChanged: (FeedbackSentiment? sentiment) {
                      context.read<FeedbackBloc>().add(SentimentChangedEvent(
                          sentiment: FeedbackSentiment.mediocre));
                    })),
            Text(FeedbackSentiment.mediocre.description,
                style: TextStyle(fontSize: 12))
          ],
        ),
        Column(
          children: [
            Transform.scale(
                scale: radioScale,
                child: Radio.adaptive(
                    value: FeedbackSentiment.good,
                    groupValue: feedbackState.serializer.sentiment,
                    onChanged: (FeedbackSentiment? sentiment) {
                      context.read<FeedbackBloc>().add(SentimentChangedEvent(
                          sentiment: FeedbackSentiment.good));
                    })),
            Text(FeedbackSentiment.good.description,
                style: TextStyle(fontSize: 12))
          ],
        ),
        Column(
          children: [
            Transform.scale(
                scale: radioScale,
                child: Radio.adaptive(
                    value: FeedbackSentiment.great,
                    groupValue: feedbackState.serializer.sentiment,
                    onChanged: (FeedbackSentiment? sentiment) {
                      context.read<FeedbackBloc>().add(SentimentChangedEvent(
                          sentiment: FeedbackSentiment.great));
                    })),
            Text(FeedbackSentiment.great.description,
                style: TextStyle(fontSize: 12))
          ],
        )
      ]);
    });
  }
}
