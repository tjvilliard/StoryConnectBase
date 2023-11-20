import 'package:flutter/material.dart';

class DeleteBookButton extends StatelessWidget {
  final VoidCallback onPressed;
  const DeleteBookButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Delete book', style: Theme.of(context).textTheme.titleLarge),
            content: const Text('Are you sure you want to delete this book?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: onPressed,
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
    );
  }
}
