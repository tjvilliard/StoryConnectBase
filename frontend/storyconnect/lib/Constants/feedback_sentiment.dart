enum FeedbackSentiment {
  good("Good"),
  great("Great"),
  mediocre("Mediocre"),
  bad("Bad");

  const FeedbackSentiment(this.description);
  final String description;
}
