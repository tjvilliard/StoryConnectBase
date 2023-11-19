import 'package:flutter/material.dart';
import 'package:storyconnect/Models/loading_struct.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

/// Panel of widgets with set behaviours and backgrounds.
abstract class ContentPanel extends StatelessWidget {
  final List<Widget> children;
  final Color primary;
  const ContentPanel({
    required this.children,
    required this.primary,
  });
}

/// Solid Background Panel.
class SolidPanel extends ContentPanel {
  const SolidPanel({required super.children, required super.primary});

  ///
  static loadingPanel({required LoadingStruct child, required Color primary}) {
    return Container(
      alignment: Alignment.center,
      constraints: BoxConstraints(minHeight: 250),
      decoration: BoxDecoration(color: primary),
      child: LoadingWidget(loadingStruct: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(minHeight: 250),
        decoration: BoxDecoration(color: this.primary),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: this.children));
  }
}

/// Gradient Background Panel.
class GradientPanel extends ContentPanel {
  final Color fade;

  const GradientPanel({
    required super.children,
    required super.primary,
    required this.fade,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
