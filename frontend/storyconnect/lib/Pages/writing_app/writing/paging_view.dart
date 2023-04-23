import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/chapter/chapter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/writing/page_sliver.dart';
import 'package:storyconnect/Pages/writing_app/writing/writing_page.dart';
import 'package:storyconnect/Pages/writing_app/writing/page_bloc.dart';

class PagingView extends StatefulWidget {
  const PagingView({super.key});

  @override
  _PagingViewState createState() => _PagingViewState();
}

class _PagingViewState extends State<PagingView>
    with AutomaticKeepAliveClientMixin {
  late final ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  Map<int, GlobalKey<WritingPageViewState>> _pageKeys = {};

  void scrollToIndex(PageBlocStruct state) {
    final index = state.navigateToIndex!;

    WritingPageViewState? pageState = _pageKeys[index]?.currentState;

    final pageOffset = (PageBloc.pageHeight) * index;
    if (pageState == null) {
      setState(() {
        _pageKeys[index] = GlobalKey<WritingPageViewState>();
      });
      ;
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scroll(state);
    });
  }

  void scroll(PageBlocStruct state) {
    final index = state.navigateToIndex!;

    final pageState = _pageKeys[index]?.currentState;

    final pageOffset = (PageBloc.pageHeight) * index;
    double to = max(0, pageOffset - 50);
    _controller.animateTo(to,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);

    ;

    if (pageState != null) {
      Scrollable.ensureVisible(pageState.context,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    } else {
      print("here");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: PageBloc.pageWidth),
        child: BlocBuilder<ChapterBloc, ChapterBlocStruct>(
            buildWhen: (previous, current) {
          return previous.currentIndex != current.currentIndex;
        }, builder: (context, state) {
          return BlocConsumer<PageBloc, PageBlocStruct>(
              listenWhen: (previous, current) {
            final bool wasFocused =
                previous.navigateToIndex == current.navigateToIndex;
            return !wasFocused && current.navigateToIndex != null;
          }, listener: (context, state) async {
            scrollToIndex(state);
          }, buildWhen: (previousStruct, currentStruct) {
            final previous = previousStruct.pages;
            final current = currentStruct.pages;
            return previous.length != current.length;
          }, builder: (context, state) {
            return CustomScrollView(
              controller: _controller,
              slivers: [
                PageSliver(
                  itemExtent: PageBloc.pageHeight,
                  delegate: SliverChildBuilderDelegate(
                    childCount: state.pages.length,
                    (BuildContext context, int index) {
                      if (!_pageKeys.containsKey(index)) {
                        _pageKeys[index] = GlobalKey<WritingPageViewState>();
                      }
                      return WritingPageView(
                        key: _pageKeys[index],
                        index: index,
                      );
                    },
                  ),
                )
              ],
            );
          });
        }));
  }

  @override
  bool get wantKeepAlive => true;
}
