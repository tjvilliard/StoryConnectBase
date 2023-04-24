import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/chapter/chapter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/writing/page_bloc.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class ChapterCreateButton extends StatelessWidget {
  const ChapterCreateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChapterBloc, ChapterBlocStruct>(
        listener: (context, state) {
      Scrollable.ensureVisible(context,
          duration: Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: 1);
    }, listenWhen: (previous, current) {
      return previous.loadingStruct != current.loadingStruct;
    }, buildWhen: (previous, current) {
      return previous.loadingStruct != current.loadingStruct;
    }, builder: (context, chapterState) {
      return BlocBuilder<PageBloc, PageBlocStruct>(
          buildWhen: (previous, current) {
        return previous.loadingStruct != current.loadingStruct;
      }, builder: (context, pageState) {
        if (chapterState.loadingStruct.isLoading) {
          return LoadingWidget(loadingStruct: chapterState.loadingStruct);
        }
        return OutlinedButton(
            onPressed: () => context.read<ChapterBloc>().add(AddChapter(
                  pageBloc: context.read<PageBloc>(),
                  callerIndex: chapterState.currentIndex,
                  callerPages: pageState.pages,
                )),
            child: Text("Add Chapter"));
      });
    });
  }
}