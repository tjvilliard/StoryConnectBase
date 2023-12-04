import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Constants/copyright_constants.dart';
import 'package:storyconnect/Constants/language_constants.dart';
import 'package:storyconnect/Constants/target_audience_constants.dart';
import 'package:storyconnect/Pages/reading_hub/search/state/search_bloc.dart';

class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<LanguageConstant>(
        enableFilter: false,
        enableSearch: false,
        onSelected: (choice) {
          context
              .read<SearchBloc>()
              .add(LanguageChangedEvent(language: choice!.label));
        },
        hintText: "Language",
        dropdownMenuEntries: const [
          DropdownMenuEntry(value: LanguageConstant.english, label: "English"),
          DropdownMenuEntry(value: LanguageConstant.french, label: "French"),
          DropdownMenuEntry(value: LanguageConstant.spanish, label: "Spanish"),
          DropdownMenuEntry(value: LanguageConstant.german, label: "German"),
          DropdownMenuEntry(
              value: LanguageConstant.indonesian, label: "Indonesian"),
        ]);
  }
}

class CopyrightDropdown extends StatelessWidget {
  const CopyrightDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<CopyrightOption>(
        enableFilter: false,
        enableSearch: false,
        onSelected: (choice) {
          context
              .read<SearchBloc>()
              .add(CopyrightChangedEvent(copyright: choice!.index));
        },
        hintText: "Copyright",
        dropdownMenuEntries: const [
          DropdownMenuEntry(
              value: CopyrightOption.allRightsReserved,
              label: "All Rights Reserved"),
          DropdownMenuEntry(
              value: CopyrightOption.publicDomain, label: "Public Domain"),
          DropdownMenuEntry(
              value: CopyrightOption.creativeCommons,
              label: "Creative Commons"),
        ]);
  }
}

class AudienceDropdown extends StatelessWidget {
  const AudienceDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<TargetAudience>(
        enableFilter: false,
        enableSearch: false,
        onSelected: (choice) {
          context
              .read<SearchBloc>()
              .add(AudienceChangedEvent(audience: choice!.index));
        },
        hintText: "Audience",
        dropdownMenuEntries: const [
          DropdownMenuEntry(value: TargetAudience.children, label: "Children"),
          DropdownMenuEntry(
              value: TargetAudience.youngAdult, label: "Young Adult"),
          DropdownMenuEntry(value: TargetAudience.adult, label: "Adult (18+)"),
        ]);
  }
}
