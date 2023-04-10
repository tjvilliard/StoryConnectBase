import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/page_views/page_sliver.dart';
import 'package:storyconnect/Pages/writing_app/page_views/writing_page.dart';
import 'package:storyconnect/Pages/writing_app/writing_app_bloc.dart';

class PagingView extends StatelessWidget {
  const PagingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: 800),
        child: BlocBuilder<PageBloc, Map<int, String>>(
            buildWhen: (previous, current) {
          return previous.length != current.length;
        }, builder: (context, state) {
          return CustomScrollView(
            slivers: [
              PageSliver(
                itemExtent: 1100,
                delegate: SliverChildBuilderDelegate(
                  childCount: context.watch<PageBloc>().state.length,
                  (BuildContext context, int index) {
                    return WritingPageView(
                      index: index,
                    );
                  },
                ),
              )
            ],
          );
        }));
  }
}
