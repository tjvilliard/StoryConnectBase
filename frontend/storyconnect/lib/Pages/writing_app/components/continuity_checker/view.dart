import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/chapter/chapter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/continuity_checker/components/continuity_list.dart';
import 'package:storyconnect/Pages/writing_app/components/continuity_checker/components/generate_continuities_button.dart';
import 'package:storyconnect/Pages/writing_app/components/continuity_checker/state/continuity_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/side_popup_header.dart';
import 'package:storyconnect/Pages/writing_app/components/ui_state/writing_ui_bloc.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class ContinuityWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WritingUIBloc, WritingUIState>(
        builder: (context, uiState) {
      return BlocBuilder<ContinuityBloc, ContinuityState>(
          builder: (context, state) {
        return AnimatedCrossFade(
            firstChild: Container(),
            secondChild: Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.all(8),
                width: 400,
                child: Card(
                    elevation: 3,
                    child: uiState.continuityCheckerShown
                        ? Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SidePopupHeader(
                                    title: "Continuity Checker",
                                    dismiss: () => BlocProvider.of<
                                            WritingUIBloc>(context)
                                        .add(ToggleContinuityCheckerEvent())),
                                SizedBox(height: 10),
                                Text(
                                    "This tool will help you find continuity errors in your story. It will also help you find plot holes and other issues that may arise from your story.",
                                    style:
                                        Theme.of(context).textTheme.titleSmall),
                                SizedBox(height: 15),
                                Expanded(
                                    child: AnimatedSwitcher(
                                        duration: Duration(milliseconds: 200),
                                        child: state.loadingStruct.isLoading
                                            ? LoadingWidget(
                                                loadingStruct: state
                                                    .loadingStruct) // This will show when loading.
                                            : ContinuityList(
                                                continuities:
                                                    state.continuities))),
                                GenerateContinuitiesButton(onPressed: () {
                                  context.read<ContinuityBloc>().add(
                                      GenerateContinuitiesEvent(context
                                          .read<ChapterBloc>()
                                          .state
                                          .currentChapterId));
                                })
                              ],
                            ))
                        : Container())),
            crossFadeState: uiState.continuityCheckerShown
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 200));
      });
    });
  }
}