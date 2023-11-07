import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/writing_app/components/ui_state/writing_ui_bloc.dart';
import 'package:visual_editor/document/models/attributes/styling-attributes.dart';
import 'package:visual_editor/visual-editor.dart';

class RichTextMenuBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WritingUIBloc, WritingUIState>(
        builder: (context, state) {
      final buttonPadding = EdgeInsets.symmetric(horizontal: 2, vertical: 3.5);
      final iconTheme = EditorIconThemeM(
        iconSelectedColor: Colors.white,
      );

      return MenuBar(
        children: [
          Padding(
              padding: buttonPadding,
              child: ToggleStyleButton(
                  icon: FontAwesomeIcons.bold,
                  controller: state.editorController,
                  attribute: BoldAttributeM(),
                  buttonsSpacing: 1,
                  iconTheme: iconTheme)),
          Padding(
              padding: buttonPadding,
              child: ToggleStyleButton(
                  icon: FontAwesomeIcons.italic,
                  controller: state.editorController,
                  attribute: ItalicAttributeM(),
                  buttonsSpacing: 1,
                  fillColor: Colors.white,
                  iconTheme: iconTheme)),
          Padding(
              padding: buttonPadding,
              child: ToggleStyleButton(
                  icon: FontAwesomeIcons.underline,
                  controller: state.editorController,
                  attribute: UnderlineAttributeM(),
                  buttonsSpacing: 1,
                  fillColor: Colors.white,
                  iconTheme: iconTheme)),
        ],
      );
    });
  }
}
