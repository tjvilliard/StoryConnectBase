import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/reading_hub/components/scroll_behavior/horizontal_scroll_behavior.dart';

class HorizontalScrollBehaviorImpl1 implements HorizontalScrollBehavior {
  final int scrollAnimationDistance;
  final int scrollAnimationDuration_MilliSeconds;

  bool _leftScroll = false;

  @override
  bool get leftScroll => this._leftScroll;

  bool _rightScroll = true;

  @override
  bool get rightScroll => this._rightScroll;

  final ScrollController _scrollController = ScrollController();

  @override
  ScrollController get scrollController => this._scrollController;

  HorizontalScrollBehaviorImpl1(
      {required this.scrollAnimationDistance,
      required this.scrollAnimationDuration_MilliSeconds});

  @override
  void animateLeft() {
    this._scrollController.animateTo(
        this._scrollController.offset - this.scrollAnimationDistance,
        duration:
            Duration(milliseconds: this.scrollAnimationDuration_MilliSeconds),
        curve: Curves.easeIn);
  }

  @override
  void animateRight() {
    this._scrollController.animateTo(
        this._scrollController.offset + this.scrollAnimationDistance,
        duration:
            Duration(milliseconds: this.scrollAnimationDuration_MilliSeconds),
        curve: Curves.easeIn);
  }
}
