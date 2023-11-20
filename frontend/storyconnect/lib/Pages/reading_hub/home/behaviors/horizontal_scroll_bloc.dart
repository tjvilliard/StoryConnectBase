import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/reading_hub/home/behaviors/horizontal_scroll_behavior_pattern.dart';

part 'horizontal_scroll_state_impl.dart';
part 'horizontal_scroll_event.dart';

typedef ScrollStateEmitter = Emitter<HorizontalScrollState>;

///
class HorizontalScrollBehaviorBloc
    extends Bloc<HorizontalScrollEvent, HorizontalScrollStateImpl>
    implements HorizontalScrollBehavior {
  /// Distance of animation travel.
  final int animationDistance;

  /// Duration of animation in milliseconds
  final int animationDuration_m_sec;

  ///
  HorizontalScrollBehaviorBloc(super.initialState,
      {required this.animationDistance,
      required this.animationDuration_m_sec}) {
    this.state.initState();
    on<ScrollLeftEvent>((event, emit) => AnimateLeft(event, emit));
    on<ScrollRightEvent>((event, emit) => AnimateRight(event, emit));
  }

  @override
  void AnimateLeft(HorizontalScrollEvent event, ScrollStateEmitter emit) {
    this.state.scrollController.animateTo(
        this.state.scrollController.offset - this.animationDistance,
        duration: Duration(milliseconds: this.animationDuration_m_sec),
        curve: Curves.easeIn);

    print(this.state.leftScroll);

    print("state changed");

    emit(HorizontalScrollStateImpl(
        state.leftScroll, state.rightScroll, state.scrollController));
  }

  @override
  void AnimateRight(HorizontalScrollEvent event, ScrollStateEmitter emit) {
    this.state.scrollController.animateTo(
        this.state.scrollController.offset + this.animationDistance,
        duration: Duration(milliseconds: this.animationDuration_m_sec),
        curve: Curves.easeIn);

    print("state changed");

    emit(HorizontalScrollStateImpl(
        state.leftScroll, state.rightScroll, state.scrollController));
  }
}
