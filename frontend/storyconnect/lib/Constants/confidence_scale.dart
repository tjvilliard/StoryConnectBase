import 'package:flutter/material.dart';

enum ConfidenceScale {
  low("Low"),
  semiLow("Semi-Low"),
  semiHigh("Semi-High"),
  high("High");

  const ConfidenceScale(this.description);
  final String description;
}

class ConfidenceChecker {
  static final condidenceIntervals = [.25, .5, .75, 1];
  static ConfidenceScale getConfidence(double confidence) {
    for (int i = 0; i < condidenceIntervals.length; i++) {
      if (confidence <= condidenceIntervals[i]) {
        return ConfidenceScale.values[i];
      }
    }
    return ConfidenceScale.high;
  }
}

final Map<ConfidenceScale, Color> confidenceColors = {
  ConfidenceScale.low: Colors.red,
  ConfidenceScale.semiLow: Colors.red[300]!,
  ConfidenceScale.semiHigh: Colors.green[300]!,
  ConfidenceScale.high: Colors.green,
};
