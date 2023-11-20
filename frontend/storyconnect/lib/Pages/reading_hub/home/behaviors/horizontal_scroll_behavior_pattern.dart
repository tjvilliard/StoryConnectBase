import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Defines behaviors a class implementing horizontal scroll behaviors should implement.
abstract interface class HorizontalScrollBehavior {
  ///
  void AnimateLeft(
      HorizontalScrollEvent event, Emitter<HorizontalScrollState> emit);

  ///
  void AnimateRight(
      HorizontalScrollEvent event, Emitter<HorizontalScrollState> emit);
}

/// Defines fields a class implementing horizontal scroll state should implement.
abstract interface class HorizontalScrollState {
  /// Gets the current scroll controller and its state.
  ScrollController get scrollController;

  /// Gets whether we are showing the scroll right button or not.
  bool get rightScroll;

  /// Gets whether we are showing the scroll left button or not.
  bool get leftScroll;

  void initState();
}

abstract class HorizontalScrollEvent {}
