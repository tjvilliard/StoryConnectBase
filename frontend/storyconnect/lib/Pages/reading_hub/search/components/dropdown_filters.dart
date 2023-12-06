import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Constants/copyright_constants.dart';
import 'package:storyconnect/Constants/language_constants.dart';
import 'package:storyconnect/Constants/target_audience_constants.dart';
import 'package:storyconnect/Pages/reading_hub/search/state/search_bloc.dart';
import 'package:storyconnect/Widgets/custom_dropdown.dart';

typedef OnSelectedCallback<T> = void Function(T value);

class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    List<LanguageConstant?> choices = [null];
    for (LanguageConstant? choice in LanguageConstant.values) {
      choices.add(choice);
    }
    return CustomDropdown<LanguageConstant?>(
        title: "Language",
        initialValue: null,
        items: choices,
        labelBuilder: (choice) =>
            choice == null ? "Select Language" : choice.label,
        onSelected: (choice) {
          context
              .read<SearchBloc>()
              .add(LanguageChangedEvent(language: choice!.label));
        });
  }
}

class CopyrightDropdown extends StatelessWidget {
  const CopyrightDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    List<CopyrightOption?> choices = [null];
    for (CopyrightOption? choice in CopyrightOption.values) {
      choices.add(choice);
    }

    return CustomDropdown(
        title: "Copyright",
        initialValue: null,
        items: choices,
        labelBuilder: (choice) => choice == null
            ? "Select Copyright"
            : choice.description.split(":")[0],
        onSelected: (choice) {
          context
              .read<SearchBloc>()
              .add(CopyrightChangedEvent(copyright: choice!.index));
        });
  }
}

class AudienceDropdown extends StatelessWidget {
  const AudienceDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    List<TargetAudience?> choices = [null];
    for (TargetAudience? choice in TargetAudience.values) {
      choices.add(choice);
    }

    return CustomDropdown(
        title: "Audience",
        initialValue: null,
        items: choices,
        labelBuilder: (choice) =>
            choice == null ? "Select Audience" : choice.label,
        onSelected: (choice) {
          context
              .read<SearchBloc>()
              .add(AudienceChangedEvent(audience: choice!.index));
        });
  }
}
