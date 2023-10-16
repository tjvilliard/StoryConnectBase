import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/continuity_checker/state/continuity_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/side_popup_header.dart';
import 'package:storyconnect/Pages/writing_app/components/ui_state/writing_ui_bloc.dart';

class ContinuityWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WritingUIBloc, WritingUIState>(
        builder: (context, uiState) {
      return BlocBuilder<ContinuityBloc, ContinuityState>(
          builder: (context, chapterState) {
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
                                    title: "Road Unblocker",
                                    dismiss: () =>
                                        BlocProvider.of<WritingUIBloc>(context)
                                            .add(ToggleRoadUnblockerEvent())),
                                SizedBox(height: 10),
                                Text(
                                    "This tool will help you find continuity errors in your story. It will also help you find plot holes and other issues that may arise from your story.",
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: constraints.maxWidth * 0.85,
                                        ),
                                        Spacer(),
                                      ],
                                    );
                                  },
                                )
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
