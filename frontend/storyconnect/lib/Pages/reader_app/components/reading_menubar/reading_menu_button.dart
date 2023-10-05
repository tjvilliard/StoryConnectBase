import 'package:flutter/material.dart';

/// A button for a menu on the Reading App Page.
/// Requires an alignment direction for the button,
/// possible alongside content.
class ReadingMenuButton extends StatelessWidget {
  final Icon? leadingIcon;
  final String? content;
  final VoidCallback onPressed;
  final Alignment alignment;

  /// A Reading Menu Button requires a direction and an action
  const ReadingMenuButton({
    super.key,
    this.leadingIcon,
    this.content,
    required this.onPressed,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: this.alignment,
      child: MenuItemButton(
        leadingIcon: leadingIcon == null ? null : this.leadingIcon,
        child: Text(this.content == null ? "" : this.content!),
        onPressed: this.onPressed,
      ),
    );
  }
}
