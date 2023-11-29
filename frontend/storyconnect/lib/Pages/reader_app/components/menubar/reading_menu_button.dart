import 'package:flutter/material.dart';

/// A button for a menu on the Reading App Page.
/// Requires an alignment direction for the button,
/// possible alongside content.
abstract class ReadingIconButton extends StatelessWidget {
  final bool disableCondition;

  static MaterialStatePropertyAll<OutlinedBorder> buttonShape = MaterialStatePropertyAll(RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(4.0),
  ));

  /// A Reading Menu Button requires a direction and an action
  const ReadingIconButton({
    super.key,
    required this.disableCondition,
  });

  @override
  Widget build(BuildContext context) {
    ButtonStyle defaultStyle = ButtonStyle(
      overlayColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.primary.withOpacity(.1)),
      iconColor: disableCondition
          ? const MaterialStatePropertyAll(Colors.grey)
          : MaterialStatePropertyAll(Theme.of(context).colorScheme.primary),
      shape: buttonShape,
    );

    return buildButton(defaultStyle);
  }

  Widget buildButton(ButtonStyle defaultStyle);
}
