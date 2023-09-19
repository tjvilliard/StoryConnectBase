import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/road_unblocker/components/content.dart';
import 'package:storyconnect/Pages/writing_app/components/road_unblocker/components/question_entry.dart';
import 'package:storyconnect/Pages/writing_app/components/road_unblocker/components/send_request_button.dart';
import 'package:storyconnect/Pages/writing_app/components/road_unblocker/state/road_unblocker_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/side_popup_header.dart';
import 'package:storyconnect/Pages/writing_app/components/ui_state/writing_ui_bloc.dart';

class RoadUnblockerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WritingUIBloc, WritingUIState>(
        builder: (context, uiState) {
      return BlocBuilder<RoadUnblockerBloc, RoadUnblockerState>(
          builder: (context, chapterState) {
        return AnimatedCrossFade(
            firstChild: Container(),
            secondChild: Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.all(8),
                width: 400,
                child: Card(
                    elevation: 3,
                    child: uiState.roadUnblockerShown
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
                                Expanded(child: RoadUnblockerContent()),
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: constraints.maxWidth * 0.85,
                                          child: QuestionEntry(),
                                        ),
                                        Spacer(),
                                        SendUnblockRequest(),
                                      ],
                                    );
                                  },
                                )
                              ],
                            ))
                        : Container())),
            crossFadeState: uiState.roadUnblockerShown
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 200));
      });
    });
  }
}
