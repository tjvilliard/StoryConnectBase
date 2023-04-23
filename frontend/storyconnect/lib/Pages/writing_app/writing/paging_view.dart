import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/chapter/chapter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/writing/page_sliver.dart';
import 'package:storyconnect/Pages/writing_app/writing/writing_page.dart';
import 'package:storyconnect/Pages/writing_app/writing/page_bloc.dart';

class PagingView extends StatelessWidget {
  const PagingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: PageBloc.pageWidth),
        child: BlocBuilder<ChapterBloc, ChapterBlocStruct>(
            buildWhen: (previous, current) {
          return previous.currentIndex != current.currentIndex;
        }, builder: (context, state) {
          return BlocBuilder<PageBloc, PageBlocStruct>(
              buildWhen: (previousStruct, currentStruct) {
            final previous = previousStruct.pages;
            final current = currentStruct.pages;
            return previous.length != current.length;
          }, builder: (context, state) {
            return CustomScrollView(
              slivers: [
                PageSliver(
                  itemExtent: PageBloc.pageHeight,
                  delegate: SliverChildBuilderDelegate(
                    childCount: state.pages.length,
                    (BuildContext context, int index) {
                      return WritingPageView(
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
}
