part of 'horizontal_scroll_bloc.dart';

///
class HorizontalScrollStateImpl implements HorizontalScrollState {
  HorizontalScrollStateImpl(
    bool leftScroll,
    bool rightScroll,
    ScrollController controller,
  ) {
    this._leftScroll = leftScroll;
    this._rightScroll = rightScroll;
    this._scrollController = controller;
  }

  ///
  late bool _leftScroll;

  @override
  bool get leftScroll => this._leftScroll;

  ///
  late bool _rightScroll;

  @override
  bool get rightScroll => this._rightScroll;

  ///
  late ScrollController _scrollController;

  @override
  ScrollController get scrollController => this._scrollController;

  @override
  void initState() {
    this._scrollController = ScrollController();

    this._leftScroll = false;

    this._rightScroll = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      this._scrollController.addListener(() {
        bool start = this._scrollController.position.pixels == 0;

        if (this._scrollController.position.atEdge) {
          if (start) {
            print("At Left");
            this._leftScroll = false;
          } else {
            print("At Right");
            this._rightScroll = false;
          }
        } else {
          this._leftScroll = true;
          this._rightScroll = true;
        }
      });
    });
  }
}
