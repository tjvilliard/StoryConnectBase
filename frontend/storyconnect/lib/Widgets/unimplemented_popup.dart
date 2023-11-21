import 'package:flutter/material.dart';

class UnimplementedPopup extends StatelessWidget {
  final String featureName;
  const UnimplementedPopup({
    super.key,
    required this.featureName,
  });

  @override
  AlertDialog build(BuildContext context) {
    return AlertDialog(
      title: const Text("Unimplemented"),
      content: Text("$featureName is not yet implemented."),
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
