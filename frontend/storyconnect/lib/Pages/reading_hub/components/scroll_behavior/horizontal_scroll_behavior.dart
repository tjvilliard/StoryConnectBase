import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

abstract interface class HorizontalScrollBehavior {
  // Static scroll members.
  static const Icon leftArrowIcon = Icon(FontAwesomeIcons.arrowLeft);
  static const Icon rightArrowIcon = Icon(FontAwesomeIcons.arrowRight);
  static const Widget zeroSpace = SizedBox.shrink();

  /// Gets the current scroll controller and its state.
  ScrollController get scrollController;

  /// Gets whether we are showing the scroll left button or not.
  bool get leftScroll;

  /// Handles the animate left function for the Horizontal Scroll List.
  void animateLeft();

  /// Gets whether we are showing the scroll right button or not.
  bool get rightScroll;

  /// Handles the animate right function for the Horizontal Scroll List.
  void animateRight();
}
