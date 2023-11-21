import 'package:flutter/material.dart';
import 'package:storyconnect/Constants/target_audience_constants.dart';
import 'package:storyconnect/Widgets/custom_dropdown.dart';

typedef OnSelected = void Function(TargetAudience audience);

class AudienceDropdown extends StatelessWidget {
  final OnSelected onSelected;
  final TargetAudience? initialValue;

  const AudienceDropdown({super.key, required this.onSelected, this.initialValue});

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<TargetAudience>(
        title: "Target Audience",
        initialValue: initialValue ?? TargetAudience.youngAdult,
        items: TargetAudience.values,
        labelBuilder: (lang) => lang.label,
        onSelected: (value) => onSelected.call(value));
  }
}
