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
  final int animationDuration_m_sec;

  ///
  HorizontalScrollBehaviorBloc(
      {required this.animationDistance, required this.animationDuration_m_sec})
      : super(HorizontalScrollState(
            leftScroll: false,
            rightScroll: true,
            scrollController: ScrollController())) {
    on<ScrollLeftEvent>((event, emit) => AnimateLeft(event, emit));
    on<ScrollRightEvent>((event, emit) => AnimateRight(event, emit));
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

  void AnimateLeft(HorizontalScrollEvent event, ScrollStateEmitter emit) async {
    await this.state.scrollController.animateTo(
        this.state.scrollController.offset - this.animationDistance,
        duration: Duration(milliseconds: this.animationDuration_m_sec),
        curve: Curves.easeIn);

    emit(this._handleState());
  }

  void AnimateRight(
      HorizontalScrollEvent event, ScrollStateEmitter emit) async {
    await this.state.scrollController.animateTo(
        this.state.scrollController.offset + this.animationDistance,
        duration: Duration(milliseconds: this.animationDuration_m_sec),
        curve: Curves.easeIn);

    emit(this._handleState());
  }
}
