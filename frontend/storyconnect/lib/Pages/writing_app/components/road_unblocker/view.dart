import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/road_unblocker/components/content.dart';
import 'package:storyconnect/Pages/writing_app/components/road_unblocker/components/question_entry.dart';
import 'package:storyconnect/Pages/writing_app/components/road_unblocker/components/send_request_button.dart';
import 'package:storyconnect/Pages/writing_app/components/side_popup_header.dart';
import 'package:storyconnect/Pages/writing_app/components/ui_state/writing_ui_bloc.dart';

class RoadUnblockerWidget extends StatelessWidget {
  const RoadUnblockerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WritingUIBloc, WritingUIState>(
        buildWhen: (previous, current) => previous.roadUnblockerShown != current.roadUnblockerShown,
        builder: (context, uiState) {
          return AnimatedCrossFade(
              firstChild: Container(),
              secondChild: Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(8),
                  width: 400,
                  child: Card(
                      elevation: 3,
                      child: uiState.roadUnblockerShown
                          ? Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SidePopupHeader(
                                      title: "Road Unblocker",
                                      dismiss: () =>
                                          BlocProvider.of<WritingUIBloc>(context).add(const ToggleRoadUnblockerEvent())),
                                  const SizedBox(height: 10),
                                  const Expanded(child: RoadUnblockerContent()),
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: constraints.maxWidth * 0.85,
                                            child: const QuestionEntry(),
                                          ),
                                          const Spacer(),
                                          const SendUnblockRequest(),
                                        ],
                                      );
                                    },
                                  )
                                ],
                              ))
                          : Container())),
              crossFadeState: uiState.roadUnblockerShown ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 500));
        });
  }
}
