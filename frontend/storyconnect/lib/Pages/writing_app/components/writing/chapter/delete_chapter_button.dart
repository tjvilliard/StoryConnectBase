import 'package:flutter/material.dart';

class DeleteChapterButton extends StatelessWidget {
  final VoidCallback onDelete;

  const DeleteChapterButton({Key? key, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.red),
      ),
      onPressed: () async {
        final shouldDelete = await _showDeleteConfirmationDialog(context);
        if (shouldDelete) {
          onDelete();
        }
      },
      child: Text(
        'Delete',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text('Confirm Delete'),
              content: Text('Are you sure you want to delete this chapter?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: Text('Delete', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        ) ??
        false; // Returns false if the dialog is dismissed without selecting any option
  }
}
