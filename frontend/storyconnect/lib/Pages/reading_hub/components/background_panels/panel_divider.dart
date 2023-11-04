import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/reading_hub/components/background_panels/content_panel.dart';

/// A material horizontal divider to be used between content panels.
class ContentDivider extends ContentPanel {
  /// The color of this divider.
  final Color color;

  /// The thickness of the line drawn by the divider.
  final double? thickness;

  ContentDivider({required this.color, this.thickness = null});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: this.color,
      thickness: this.thickness,
      height: 0.0,
      indent: 0,
      endIndent: 0,
    );
  }
}
