import 'package:flutter/material.dart';

/// Panel of widgets with set behaviours and backgrounds.
abstract class ContentPanel extends StatelessWidget {
  const ContentPanel();
}

/// Solid Background Panel.
class SolidPanel extends ContentPanel {
  final List<Widget> children;
  final Color primary;

  const SolidPanel({
    required this.children,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(color: this.primary),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: this.children));
  }
}

/// Gradient Background Panel.
class GradientPanel extends ContentPanel {
  final List<Widget> children;
  final Color primary;
  final Color fade;

  const GradientPanel({
    required this.children,
    required this.primary,
    required this.fade,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [this.primary, this.fade],
          stops: [0.0, .99],
        )),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: this.children));
  }
}
