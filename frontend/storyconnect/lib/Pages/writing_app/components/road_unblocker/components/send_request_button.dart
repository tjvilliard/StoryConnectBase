import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/writing_app/components/road_unblocker/state/road_unblocker_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/ui_state/writing_ui_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/writing/_state/writing_bloc.dart';

class SendUnblockRequest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
        onPressed: () {
          final WritingBloc writingBloc = context.read<WritingBloc>();
          final WritingUIBloc uiBloc = context.read<WritingUIBloc>();
          final TextSelection selection = uiBloc.state.editorController.selection;
          final String selectedText =
              selection.textInside(writingBloc.state.getCurrentChapterRawText().trim().replaceAll("\\s+", ""));

          context
              .read<RoadUnblockerBloc>()
              .add(SubmitUnblockEvent(selection: selectedText, chapterID: writingBloc.state.currentChapterId));
        },
        icon: Icon(FontAwesomeIcons.paperPlane));
  }
}
