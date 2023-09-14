import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:storyconnect/Pages/writing_app/comments/state/feedback_bloc.dart';
import 'package:storyconnect/Pages/writing_app/ui_state/writing_ui_bloc.dart';

class RoadUnblockerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WritingUIBloc, WritingUIState>(
      builder: (context, uiState) {
        return AnimatedCrossFade(
          firstChild: Container(),
          secondChild: uiState.roadUnblockerShown
              ? BlocBuilder<FeedbackBloc, FeedbackState>(
                  builder: (context, state) {
                    return Card(child: Text("Road Unblocker"));
                  },
                )
              : Container(),
          crossFadeState: uiState.roadUnblockerShown
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 200),
        );
      },
    );
  }
}
