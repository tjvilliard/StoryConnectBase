import 'dart:ui';

enum FeedbackSentiment {
  great("Great"),
  good("Good"),
  mediocre("Mediocre"),
  bad("Bad");

  const FeedbackSentiment(this.description);
  final String description;
}

Map<FeedbackSentiment, Color> feedbackColor = {
  FeedbackSentiment.good: const Color(0xFF00FF00),
  FeedbackSentiment.great: const Color.fromARGB(255, 0, 116, 0),
  FeedbackSentiment.mediocre: const Color.fromARGB(255, 223, 253, 0),
  FeedbackSentiment.bad: const Color.fromARGB(255, 195, 0, 0),
};
