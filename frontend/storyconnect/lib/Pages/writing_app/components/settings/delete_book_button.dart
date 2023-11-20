import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/writing_app/components/ui_state/writing_ui_bloc.dart';
import 'package:storyconnect/Services/url_service.dart';

class DeleteBookButton extends StatelessWidget {
  const DeleteBookButton({
    Key? key,
  }) : super(key: key);

  Future<bool> showConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Are you sure?"),
        content: Text("This will irretrievably delete your book."),
        actions: [
          TextButton(
            child: Text("No"),
            onPressed: () => Navigator.of(context).pop(false), // passing 'false' when No is pressed
          ),
          TextButton(
            child: Text("Yes"),
            onPressed: () => Navigator.of(context).pop(true), // passing 'true' when Yes is pressed
          ),
        ],
      ),
    );

    return result ?? false; // Return false if the dialog is dismissed
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.red),
      ),
      label: Text("Delete book"),
      icon: const Icon(FontAwesomeIcons.solidTrashCan),
      onPressed: () async {
        final value = await showConfirmationDialog(context);
        if (value) {
          Navigator.of(context).pop(); // pop the dialog
          Beamer.of(context).beamToNamed(PageUrls.writerHome);

          context.read<WritingUIBloc>().add(DeleteBookEvent());
        }
      },
    );
  }
}
