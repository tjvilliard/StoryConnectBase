import 'dart:math';
import 'package:flutter/material.dart';

// see https://stackoverflow.com/questions/67798844/sliver-not-allowing-to-set-max-width-of-container

class ConstrainedSliverWidth extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  const ConstrainedSliverWidth({
    Key? key,
    required this.child,
    required this.maxWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var padding = (size.width - maxWidth) / 2;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: max(padding, 0)),
      child: child,
    );
  }
}
