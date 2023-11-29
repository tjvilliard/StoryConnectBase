import 'package:flutter/material.dart';

class DescriptionPopup extends StatelessWidget {
  final String featureName;
  final String description;
  const DescriptionPopup({
    super.key,
    required this.featureName,
    required this.description,
  });

  @override
  AlertDialog build(BuildContext context) {
    return AlertDialog(
      title: Text("What is a $featureName?"),
      content: Text(description),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"))
      ],
    );
  }
}
