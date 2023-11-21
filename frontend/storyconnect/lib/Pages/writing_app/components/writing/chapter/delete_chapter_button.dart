import 'package:flutter/material.dart';

class DeleteChapterButton extends StatelessWidget {
  final VoidCallback onDelete;
  final bool canDelete;
  final String? cantDeleteReason;

  DeleteChapterButton({
    super.key,
    required this.onDelete,
    required this.canDelete,
    this.cantDeleteReason,
  }) {
    if (canDelete == false) {
      assert(cantDeleteReason != null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.red),
      ),
      onPressed: () async {
        // if we can't delete,
        if (canDelete != true) {
          // show a snackbar with the reason why
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(cantDeleteReason!),
              duration: const Duration(seconds: 6),
            ),
          );
          return;
        }

        final shouldDelete = await _showDeleteConfirmationDialog(context);
        if (shouldDelete && canDelete) {
          onDelete();
        }
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      },
      child: const Text(
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
              title: const Text('Confirm Delete'),
              content: const Text('Are you sure you want to delete this chapter?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: const Text('Delete', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        ) ??
        false; // Returns false if the dialog is dismissed without selecting any option
  }
}
