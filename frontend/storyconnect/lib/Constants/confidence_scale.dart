import 'package:flutter/material.dart';

enum ConfidenceScale {
  low("Low"),
  semi_low("Semi-Low"),
  semi_high("Semi-High"),
  high("High");

  const ConfidenceScale(this.description);
  final String description;
}

class ConfidenceChecker {
  static final _condidence_intervals = [.25, .5, .75, 1];
  static ConfidenceScale getConfidence(double confidence) {
    for (int i = 0; i < _condidence_intervals.length; i++) {
      if (confidence <= _condidence_intervals[i]) {
        return ConfidenceScale.values[i];
      }
    }
    return ConfidenceScale.high;
  }
}

final Map<ConfidenceScale, Color> confidenceColors = {
  ConfidenceScale.low: Colors.red,
  ConfidenceScale.semi_low: Colors.red[300]!,
  ConfidenceScale.semi_high: Colors.green[300]!,
  ConfidenceScale.high: Colors.green,
};
