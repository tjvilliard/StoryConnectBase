import 'package:flutter/material.dart';

/// Panel of widgets with set behaviours and backgrounds.
abstract class ContentPanel extends StatelessWidget {
  const ContentPanel({super.key});
}

/// Solid Background Panel.
class SolidPanel extends ContentPanel {
  final List<Widget> children;
  final Color primary;

  const SolidPanel({super.key, 
    required this.children,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(color: primary),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children));
  }
}

/// Gradient Background Panel.
class GradientPanel extends ContentPanel {
  final List<Widget> children;
  final Color primary;
  final Color fade;

  const GradientPanel({super.key, 
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
          colors: [primary, fade],
          stops: const [0.0, .99],
        )),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children));
  }
}
