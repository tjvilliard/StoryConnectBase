import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/chapter/chapter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/writing/page_sliver.dart';
import 'package:storyconnect/Pages/writing_app/writing/writing_page.dart';
import 'package:storyconnect/Pages/writing_app/writing/page_bloc.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class PagingView extends StatelessWidget {
  const PagingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: 800),
        child: BlocBuilder<ChapterBloc, ChapterBlocStruct>(
            buildWhen: (previous, current) {
          return previous.currentIndex != current.currentIndex;
        }, builder: (context, state) {
          return BlocBuilder<PageBloc, PageBlocStruct>(
              buildWhen: (previous, current) {
            return previous != current ||
                state.loadingStruct != current.loadingStruct;
          }, builder: (context, state) {
            if (state.loadingStruct.isLoading) {
              return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 100),
                  child: LoadingWidget(loadingStruct: state.loadingStruct));
            }

            return CustomScrollView(
              slivers: [
                PageSliver(
                  itemExtent: 1100,
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
