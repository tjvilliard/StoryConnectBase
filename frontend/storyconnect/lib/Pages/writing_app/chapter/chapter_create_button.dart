import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/chapter/chapter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/writing/page_bloc.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class ChapterCreateButton extends StatefulWidget {
  const ChapterCreateButton({super.key});

  @override
  State<ChapterCreateButton> createState() => _ChapterCreateButtonState();
}

class _ChapterCreateButtonState extends State<ChapterCreateButton> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChapterBloc, ChapterBlocStruct>(
        buildWhen: (previous, current) {
      return previous.loadingStruct != current.loadingStruct;
    }, builder: (context, chapterState) {
      if (chapterState.loadingStruct.isLoading) {
        return LoadingWidget(loadingStruct: chapterState.loadingStruct);
      }
      return OutlinedButton(
          onPressed: () => context.read<ChapterBloc>().add(AddChapter(
                pageBloc: context.read<PageBloc>(),
                callerIndex: chapterState.currentIndex,
                callerPages: context.read<PageBloc>().state.pages,
              )),
          child: Text("Add Chapter"));
    });
  }
}
