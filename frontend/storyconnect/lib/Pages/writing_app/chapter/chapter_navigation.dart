import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/writing_ui_bloc.dart';

class ChapterNavigation extends StatelessWidget {
  const ChapterNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WritingUIBloc, WritingUIStatus>(
        buildWhen: (previous, current) {
      return previous.chapterOutlineShown != current.chapterOutlineShown;
    }, builder: (context, state) {
      return AnimatedCrossFade(
          firstChild: Container(),
          secondChild: Container(
              color: Colors.white,
              padding: EdgeInsets.all(25),
              constraints: BoxConstraints(minWidth: 150, maxWidth: 300),
              child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: OutlinedButton(
                            onPressed: () {},
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text("Chapter ${index + 1}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.copyWith()),
                            )));
                  })),
          crossFadeState: state.chapterOutlineShown
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 200));
    });
  }
}
