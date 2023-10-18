import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/writing_app/components/chapter/chapter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/narrative_sheet/popup.dart';
import 'package:storyconnect/Pages/writing_app/components/ui_state/writing_ui_bloc.dart';
import 'package:storyconnect/Widgets/unimplemented_popup.dart';

class WritingMenuBar extends StatelessWidget {
  const WritingMenuBar({super.key});

  Future<void> showPopup(String caller, BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return UnimplementedPopup(featureName: caller);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(16),
        child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MenuBar(children: [
                    MenuItemButton(
                      leadingIcon: Icon(FontAwesomeIcons.list),
                      child: Text("Chapters"),
                      onPressed: () {
                        BlocProvider.of<WritingUIBloc>(context)
                            .add(ToggleChapterOutlineEvent());
                      },
                    ),
                  ]),
                  MenuBar(
                      style: MenuStyle(
                          alignment: Alignment.centerLeft,
                          maximumSize:
                              MaterialStatePropertyAll(Size(500, 200))),
                      children: [
                        MenuItemButton(
                            leadingIcon: Icon(FontAwesomeIcons.arrowRotateLeft),
                            child: Container(),
                            onPressed: () {
                              context.read<ChapterBloc>().add(UndoCommand());
                            }),
                        MenuItemButton(
                            leadingIcon:
                                Icon(FontAwesomeIcons.arrowRotateRight),
                            child: Container(),
                            onPressed: () {
                              context.read<ChapterBloc>().add(RedoCommand());
                            }),
                      ]),
                  MenuBar(children: [
                    MenuItemButton(
                        leadingIcon: Icon(FontAwesomeIcons.comment),
                        child: Text("Feedback"),
                        onPressed: () {
                          BlocProvider.of<WritingUIBloc>(context)
                              .add(ToggleFeedbackUIEvent());
                        }),
                    MenuItemButton(
                        leadingIcon: Icon(FontAwesomeIcons.lightbulb),
                        child: Text("RoadUnblocker"),
                        onPressed: () {
                          BlocProvider.of<WritingUIBloc>(context)
                              .add(ToggleRoadUnblockerEvent());
                        }),
                    MenuItemButton(
                        leadingIcon: Icon(FontAwesomeIcons.check),
                        child: Text("Narrative Elements Sheet"),
                        onPressed: () {
                          final bookId =
                              context.read<WritingUIBloc>().state.bookId;
                          Navigator.of(context)
                              .push(NarrativeSheetPopup(bookId));
                        }),
                    MenuItemButton(
                        leadingIcon: Icon(FontAwesomeIcons.book),
                        child: Text("Continuity Checker"),
                        onPressed: () {
                          BlocProvider.of<WritingUIBloc>(context)
                              .add(ToggleContinuityCheckerEvent());
                        }),
                  ]),
                ])));
  }
}
