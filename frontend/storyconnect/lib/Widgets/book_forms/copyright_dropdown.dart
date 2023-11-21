import 'package:flutter/material.dart';
import 'package:storyconnect/Constants/copyright_constants.dart';
import 'package:storyconnect/Widgets/custom_dropdown.dart';

typedef OnCopyrightSelected = void Function(CopyrightOption);

class CopyrightDropdown extends StatelessWidget {
  final OnCopyrightSelected onSelected;
  final CopyrightOption? initialValue;

  const CopyrightDropdown({
    super.key,
    required this.onSelected,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<CopyrightOption>(
      title: "Copyright Options",
      initialValue: initialValue ?? CopyrightOption.allRightsReserved,
      items: CopyrightOption.values,
      labelBuilder: (copy) => copy.description.split(":")[0],
      onSelected: (value) => onSelected.call(value),
    );
  }
}
