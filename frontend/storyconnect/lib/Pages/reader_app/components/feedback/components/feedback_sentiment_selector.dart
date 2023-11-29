import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Constants/feedback_sentiment.dart';
import 'package:storyconnect/Pages/reader_app/components/feedback/state/feedback_bloc.dart';

class SentimentSelectorWidget extends StatelessWidget {
  const SentimentSelectorWidget({super.key});

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
                    value: FeedbackSentiment.bad.index,
                    groupValue: feedbackState.serializer.sentiment,
                    onChanged: (int? sentiment) {
                      context.read<FeedbackBloc>().add(SentimentChangedEvent(
                          sentiment: FeedbackSentiment.bad.index));
                    })),
            Text(
              FeedbackSentiment.bad.description,
              style: const TextStyle(fontSize: 12),
            )
          ],
        ),
        Column(
          children: [
            Transform.scale(
                scale: radioScale,
                child: Radio.adaptive(
                    value: FeedbackSentiment.mediocre.index,
                    groupValue: feedbackState.serializer.sentiment,
                    onChanged: (int? sentiment) {
                      context.read<FeedbackBloc>().add(SentimentChangedEvent(
                          sentiment: FeedbackSentiment.mediocre.index));
                    })),
            Text(FeedbackSentiment.mediocre.description,
                style: const TextStyle(fontSize: 12))
          ],
        ),
        Column(
          children: [
            Transform.scale(
                scale: radioScale,
                child: Radio.adaptive(
                    value: FeedbackSentiment.good.index,
                    groupValue: feedbackState.serializer.sentiment,
                    onChanged: (int? sentiment) {
                      context.read<FeedbackBloc>().add(SentimentChangedEvent(
                          sentiment: FeedbackSentiment.good.index));
                    })),
            Text(FeedbackSentiment.good.description,
                style: const TextStyle(fontSize: 12))
          ],
        ),
        Column(
          children: [
            Transform.scale(
                scale: radioScale,
                child: Radio.adaptive(
                    value: FeedbackSentiment.great.index,
                    groupValue: feedbackState.serializer.sentiment,
                    onChanged: (int? sentiment) {
                      context.read<FeedbackBloc>().add(SentimentChangedEvent(
                          sentiment: FeedbackSentiment.great.index));
                    })),
            Text(FeedbackSentiment.great.description,
                style: const TextStyle(fontSize: 12))
          ],
        )
      ]);
    });
  }
}
