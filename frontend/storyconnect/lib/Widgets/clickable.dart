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
    return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(2, 5),
          )
        ]),
        child: ClipRRect(
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
                ))));
  }
}
