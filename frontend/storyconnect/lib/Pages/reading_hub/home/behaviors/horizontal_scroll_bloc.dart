import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'horizontal_scroll_state.dart';
part 'horizontal_scroll_event.dart';

typedef ScrollStateEmitter = Emitter<HorizontalScrollState>;

///
class HorizontalScrollBehaviorBloc
    extends Bloc<HorizontalScrollEvent, HorizontalScrollState> {
  /// Distance of animation travel.
  final int animationDistance;

  /// Duration of animation in milliseconds
  final int animationDurationMsec;

  ///
  HorizontalScrollBehaviorBloc(
      {required this.animationDistance, required this.animationDurationMsec})
      : super(HorizontalScrollState(
            leftScroll: false,
            rightScroll: true,
            scrollController: ScrollController())) {
    on<ScrollLeftEvent>((event, emit) => animateLeft(event, emit));
    on<ScrollRightEvent>((event, emit) => animateRight(event, emit));
  }

  HorizontalScrollState _handleState() {
    bool start = state.scrollController.position.pixels == 0;
    bool leftScroll = true;
    bool rightScroll = true;

    if (state.scrollController.position.atEdge) {
      if (start) {
        leftScroll = false;
      } else {
        rightScroll = false;
      }
    } else {
      leftScroll = true;
      rightScroll = true;
    }

    return HorizontalScrollState(
      leftScroll: leftScroll,
      rightScroll: rightScroll,
      scrollController: state.scrollController,
    );
  }

  void animateLeft(HorizontalScrollEvent event, ScrollStateEmitter emit) async {
    await state.scrollController.animateTo(
        state.scrollController.offset - animationDistance,
        duration: Duration(milliseconds: animationDurationMsec),
        curve: Curves.easeIn);

    emit(_handleState());
  }

  void animateRight(
      HorizontalScrollEvent event, ScrollStateEmitter emit) async {
    await state.scrollController.animateTo(
        state.scrollController.offset + animationDistance,
        duration: Duration(milliseconds: animationDurationMsec),
        curve: Curves.easeIn);

    emit(_handleState());
  }
}
