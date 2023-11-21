import 'package:flutter/material.dart';

class GenerateContinuitiesButton extends StatelessWidget {
  const GenerateContinuitiesButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return SizedBox(
        height: 40,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(
            'Generate Continuities',
            style: textTheme.labelMedium,
          ),
        ));
  }
}
