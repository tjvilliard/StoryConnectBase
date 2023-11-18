import 'package:flutter/material.dart';

class HoverButton extends StatefulWidget {
  final Widget label;
  final Widget icon;
  final VoidCallback onPressed;
  const HoverButton({super.key, required this.label, required this.icon, required this.onPressed});

  @override
  _HoverButtonState createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() => _isHovered = true),
      onExit: (event) => setState(() => _isHovered = false),
      child: Opacity(
        opacity: _isHovered ? 1.0 : 0.85, // Less transparent when hovered
        child: Center(
          child: FilledButton.tonalIcon(onPressed: widget.onPressed, label: widget.label, icon: widget.icon),
        ),
      ),
    );
  }
}
