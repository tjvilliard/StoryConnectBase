import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/reader_app/components/menubar/reading_menubar.dart';

/// A button for a menu on the Reading App Page.
/// Requires an alignment direction for the button,
/// possible alongside content.
class ReadingIconButton extends StatelessWidget {
  final Icon? icon;
  final String? label;
  final VoidCallback? onPressed;

  static ButtonStyle DefaultStyle = ButtonStyle(
      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(2.0),
  )));

  /// A Reading Menu Button requires a direction and an action
  const ReadingIconButton({
    super.key,
    this.icon,
    this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    ButtonStyle defaultStyle = ButtonStyle(
      iconColor: this.onPressed == null
          ? MaterialStatePropertyAll(Colors.grey)
          : MaterialStatePropertyAll(Theme.of(context).colorScheme.primary),
      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      )),
    );

    if (this.label == null) {
      //return icon button
      return Container(
          height: ReadingMenuBar.height,
          width: ReadingMenuBar.height,
          child: IconButton(
            style: defaultStyle,
            onPressed: this.onPressed,
            icon: this.icon!,
          ));
    } else if (this.icon == null) {
      //return text button
      return Container(
          height: ReadingMenuBar.height,
          child: TextButton(
            style: defaultStyle,
            onPressed: this.onPressed,
            child: Text(this.label!),
          ));
    } else {
      //return text button with icon
      return Container(
          height: ReadingMenuBar.height,
          child: TextButton.icon(
            style: defaultStyle,
            onPressed: this.onPressed,
            icon: this.icon!,
            label: Text(this.label!),
          ));
    }
  }
}
