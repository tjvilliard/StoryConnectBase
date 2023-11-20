import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/ui_state/writing_ui_bloc.dart';
import 'package:storyconnect/Widgets/book_forms/save_book_button.dart';

class UpdateBookButton extends StatelessWidget {
  const UpdateBookButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WritingUIBloc, WritingUIState>(builder: (context, state) {
      return SaveBookButton(
          text: "Update Book",
          onPressed: state.bookEditorState == null
              ? () {}
              : () => {context.read<WritingUIBloc>().add(UpdateBookEvent()), Navigator.of(context).pop()});
    });
  }
}
