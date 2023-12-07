import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Constants/copyright_constants.dart';
import 'package:storyconnect/Constants/language_constants.dart';
import 'package:storyconnect/Constants/target_audience_constants.dart';
import 'package:storyconnect/Pages/reading_hub/search/components/nullable_dropdown.dart';
import 'package:storyconnect/Pages/reading_hub/search/state/search_bloc.dart';

typedef OnSelectedCallback<T> = void Function(T value);

class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return NullableDropdown<LanguageConstant?>(
        title: "Language",
        choices: LanguageConstant.values,
        labelBuilder: (choice) =>
            choice == null ? "Select Language" : choice.label,
        onSelected: (choice) {
          context
              .read<SearchBloc>()
              .add(LanguageChangedEvent(language: choice));
        });
  }
}

class CopyrightDropdown extends StatelessWidget {
  const CopyrightDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return NullableDropdown<CopyrightOption?>(
        title: "Copyright",
        choices: CopyrightOption.values,
        labelBuilder: (choice) => choice == null
            ? "Select Copyright"
            : choice.description.split(":")[0],
        onSelected: (choice) {
          context
              .read<SearchBloc>()
              .add(CopyrightChangedEvent(copyright: choice));
        });
  }
}

class AudienceDropdown extends StatelessWidget {
  const AudienceDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return NullableDropdown<TargetAudience?>(
        title: "Audience",
        choices: TargetAudience.values,
        labelBuilder: (choice) =>
            choice == null ? "Select Audience" : choice.label,
        onSelected: (choice) {
          context
              .read<SearchBloc>()
              .add(AudienceChangedEvent(audience: choice));
        });
  }
}
