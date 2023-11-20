import 'package:flutter/material.dart';
import 'package:storyconnect/Constants/language_constants.dart';
import 'package:storyconnect/Widgets/custom_dropdown.dart';

typedef OnSelected = void Function(LanguageConstant language);

class LanguageDropdown extends StatelessWidget {
  final OnSelected onSelected;
  final LanguageConstant? initialValue;

  const LanguageDropdown({super.key, required this.onSelected, this.initialValue});

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<LanguageConstant>(
      title: "Language",
      initialValue: initialValue ?? LanguageConstant.english,
      items: LanguageConstant.values,
      labelBuilder: (lang) => lang.label,
      onSelected: (language) => onSelected.call(language),
    );
  }
}
