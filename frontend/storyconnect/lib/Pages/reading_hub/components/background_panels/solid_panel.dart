import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/reading_hub/components/background_panels/content_panel.dart';

///
class SolidContentPanel extends ContentPanel {
  final List<Widget> children;
  final Color primary;

  const SolidContentPanel({
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
