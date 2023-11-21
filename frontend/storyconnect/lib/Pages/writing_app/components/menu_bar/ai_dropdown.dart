import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/writing_app/components/narrative_sheet/popup.dart';
import 'package:storyconnect/Pages/writing_app/components/ui_state/writing_ui_bloc.dart';

class AIDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SubmenuButton(
      leadingIcon: Icon(FontAwesomeIcons.robot),
      child: Row(
        children: [
          SizedBox(
            width: 5,
          ),
          Text("Smart Assistants"),
        ],
      ),
      menuChildren: [
        MenuItemButton(
          leadingIcon: Icon(FontAwesomeIcons.lightbulb),
          child: Text("RoadUnblocker"),
          onPressed: () {
            BlocProvider.of<WritingUIBloc>(context)
                .add(ToggleRoadUnblockerEvent());
          },
        ),
        MenuItemButton(
          leadingIcon: Icon(FontAwesomeIcons.check),
          child: Text("Narrative Elements Sheet"),
          onPressed: () {
            final bookId = context.read<WritingUIBloc>().state.bookId;
            Navigator.of(context).push(NarrativeSheetPopup(bookId));
          },
        ),
        MenuItemButton(
          leadingIcon: Icon(FontAwesomeIcons.book),
          child: Text("Continuity Checker"),
          onPressed: () {
            BlocProvider.of<WritingUIBloc>(context)
                .add(ToggleContinuityCheckerEvent());
          },
        ),
      ],
    );
  }
}
