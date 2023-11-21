import 'package:flutter/material.dart';

// To be used for the body of a page. Puts constraints so that
// really wide screens don't look weird.

class Body extends StatelessWidget {
  final Widget child;
  final BoxConstraints constraints;
  Body(
      {required this.child,
      this.constraints = const BoxConstraints(maxWidth: 800)});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: ConstrainedBox(
        constraints: constraints,
        child: child,
      ),
    );
  }
}
