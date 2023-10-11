import 'package:flutter/material.dart';

/// A button for a menu on the Reading App Page.
/// Requires an alignment direction for the button,
/// possible alongside content.
class ReadingMenuButton extends StatelessWidget {
  final Icon? icon;
  final String? label;
  final VoidCallback onPressed;

  static ButtonStyle ReadingMenuButtonStyle = ButtonStyle(
      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(2.0),
  )));

  /// A Reading Menu Button requires a direction and an action
  const ReadingMenuButton({
    super.key,
    this.icon,
    this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (this.label == null) {
      return ElevatedButton(
        style: ReadingMenuButtonStyle,
        onPressed: this.onPressed,
        child: this.icon!,
      );
    } else if (this.icon == null) {
      return ElevatedButton(
        style: ReadingMenuButtonStyle,
        onPressed: this.onPressed,
        child: Text(this.label!),
      );
    } else {
      return ElevatedButton.icon(
        style: ReadingMenuButtonStyle,
        onPressed: this.onPressed,
        icon: this.icon!,
        label: Text(this.label!),
      );
    }
  }
}
