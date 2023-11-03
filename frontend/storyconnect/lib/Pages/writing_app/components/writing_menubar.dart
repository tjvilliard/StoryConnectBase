import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/writing_app/components/chapter/chapter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/ui_state/writing_ui_bloc.dart';
import 'package:storyconnect/Pages/writing_app/writing_ai_menu_bar.dart';
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
    return Padding(
        padding: EdgeInsets.only(top: 15, bottom: 15, left: 40),
        child: MenuBar(children: [
          MenuItemButton(
            leadingIcon: Icon(FontAwesomeIcons.list),
            child: Text("Chapters"),
            onPressed: () {
              BlocProvider.of<WritingUIBloc>(context)
                  .add(ToggleChapterOutlineEvent());
            },
          ),
          MenuItemButton(
            leadingIcon: Icon(FontAwesomeIcons.comment),
            child: Text("Feedback"),
            onPressed: () {
              BlocProvider.of<WritingUIBloc>(context)
                  .add(ToggleFeedbackUIEvent());
            },
          ),
          MenuItemButton(
              leadingIcon: Icon(FontAwesomeIcons.arrowRotateLeft),
              child: Container(),
              onPressed: () {
                context.read<ChapterBloc>().add(UndoCommand());
              }),
          MenuItemButton(
              leadingIcon: Icon(FontAwesomeIcons.arrowRotateRight),
              child: Container(),
              onPressed: () {
                context.read<ChapterBloc>().add(RedoCommand());
              }),
          DropDownMenuBar()
        ]));
  }
}
