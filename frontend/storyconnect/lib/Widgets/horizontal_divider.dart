import 'package:flutter/material.dart';

class HorizontalDivider extends StatelessWidget {
  final double height;
  final Color? color;

  const HorizontalDivider({super.key, this.height = 1, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: 1,
      color: color ?? Theme.of(context).dividerColor,
    );
  }
}
