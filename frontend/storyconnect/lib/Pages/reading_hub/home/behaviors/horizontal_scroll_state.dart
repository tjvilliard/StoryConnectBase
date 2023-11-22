part of 'horizontal_scroll_bloc.dart';

///
class HorizontalScrollState {
  ///
  final bool leftScroll;

  ///
  final bool rightScroll;

  ///
  final ScrollController scrollController;

  HorizontalScrollState(
      {required this.leftScroll,
      required this.rightScroll,
      required this.scrollController});
}
