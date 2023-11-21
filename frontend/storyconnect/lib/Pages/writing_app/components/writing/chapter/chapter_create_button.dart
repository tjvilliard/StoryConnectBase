import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/_state/writing_bloc.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class ChapterCreateButton extends StatelessWidget {
  const ChapterCreateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WritingBloc, WritingState>(listener: (context, state) {
      Scrollable.ensureVisible(context,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: 1);
    }, listenWhen: (previous, current) {
      return previous.loadingStruct != current.loadingStruct;
    }, buildWhen: (previous, current) {
      return previous.loadingStruct != current.loadingStruct;
    }, builder: (context, writingState) {
      if (writingState.loadingStruct.isLoading) {
        return LoadingWidget(loadingStruct: writingState.loadingStruct);
      }
      return OutlinedButton(
          onPressed: () => context.read<WritingBloc>().add(AddChapterEvent()),
          child: const Text("Add Chapter"));
    });
  }
}
