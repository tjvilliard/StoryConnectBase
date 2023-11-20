import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/writing_app/components/ui_state/writing_ui_bloc.dart';
import 'package:storyconnect/Widgets/book_forms/book_form_fields.dart';

/// A dialog that allows the user to change the book settings.

class BookSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Stack(children: [
      Container(
        constraints: BoxConstraints(maxWidth: 550, minHeight: 500),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Book Settings", style: Theme.of(context).textTheme.displaySmall),
                SizedBox(width: 15),
                Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Icon(FontAwesomeIcons.book, size: 25, color: Theme.of(context).colorScheme.secondary))
              ],
            ),
            BlocBuilder<WritingUIBloc, WritingUIState>(builder: (context, state) {
              return BookFormFields(callbacks: BookFormFieldCallbacks.empty());
            })
          ],
        ),
      ),
    ]));
  }

  Future<bool> showConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Are you sure?"),
        content: Text("This will irretrivably delete your book."),
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
}
