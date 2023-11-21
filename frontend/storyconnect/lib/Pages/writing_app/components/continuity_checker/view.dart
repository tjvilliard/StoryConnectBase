import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/_state/writing_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/continuity_checker/components/continuity_list.dart';
import 'package:storyconnect/Pages/writing_app/components/continuity_checker/components/generate_continuities_button.dart';
import 'package:storyconnect/Pages/writing_app/components/continuity_checker/state/continuity_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/side_popup_header.dart';
import 'package:storyconnect/Pages/writing_app/components/ui_state/writing_ui_bloc.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class ContinuityWidget extends StatelessWidget {
  const ContinuityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WritingUIBloc, WritingUIState>(builder: (context, uiState) {
      return BlocBuilder<ContinuityBloc, ContinuityState>(builder: (context, state) {
        return AnimatedCrossFade(
            firstChild: Container(),
            secondChild: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(8),
                width: 400,
                child: Card(
                    elevation: 3,
                    child: uiState.continuityCheckerShown
                        ? Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SidePopupHeader(
                                    title: "Continuity Checker",
                                    dismiss: () =>
                                        BlocProvider.of<WritingUIBloc>(context).add(const ToggleContinuityCheckerEvent())),
                                const SizedBox(height: 10),
                                Text(
                                    "This tool will help you find continuity errors in your story. It will also help you find plot holes and other issues that may arise from your story.",
                                    style: Theme.of(context).textTheme.titleSmall),
                                const SizedBox(height: 15),
                                Expanded(
                                    child: AnimatedSwitcher(
                                        duration: const Duration(milliseconds: 500),
                                        child: state.loadingStruct.isLoading
                                            ? LoadingWidget(
                                                loadingStruct: state.loadingStruct) // This will show when loading.
                                            : ContinuityList(continuities: state.continuities))),
                                GenerateContinuitiesButton(onPressed: () {
                                  context.read<ContinuityBloc>().add(
                                      GenerateContinuitiesEvent(context.read<WritingBloc>().state.currentChapterId));
                                })
                              ],
                            ))
                        : Container())),
            crossFadeState: uiState.continuityCheckerShown ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 500));
      });
    });
  }
}
