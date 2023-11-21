import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/writing_app/components/narrative_sheet/popup.dart';
import 'package:storyconnect/Pages/writing_app/components/ui_state/writing_ui_bloc.dart';

class AIDropdown extends StatelessWidget {
  const AIDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return SubmenuButton(
      leadingIcon: const Icon(FontAwesomeIcons.robot),
      menuChildren: [
        MenuItemButton(
          leadingIcon: const Icon(FontAwesomeIcons.lightbulb),
          child: const Text("RoadUnblocker"),
          onPressed: () {
            BlocProvider.of<WritingUIBloc>(context)
                .add(const ToggleRoadUnblockerEvent());
          },
        ),
        MenuItemButton(
          leadingIcon: const Icon(FontAwesomeIcons.check),
          child: const Text("Narrative Elements Sheet"),
          onPressed: () {
            final bookId = context.read<WritingUIBloc>().state.bookId;
            Navigator.of(context).push(NarrativeSheetPopup(bookId));
          },
        ),
        MenuItemButton(
          leadingIcon: const Icon(FontAwesomeIcons.book),
          child: const Text("Continuity Checker"),
          onPressed: () {
            BlocProvider.of<WritingUIBloc>(context)
                .add(const ToggleContinuityCheckerEvent());
          },
        ),
      ],
      child: const Row(
        children: [
          SizedBox(
            width: 5,
          ),
          Text("Smart Assistants"),
        ],
      ),
    );
  }
}
