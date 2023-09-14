import 'package:flutter/material.dart';

class Clickable extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const Clickable({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Stack(
              children: [
                child,
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onPressed,
                    ),
                  ),
                )
              ],
            )));
  }
}
