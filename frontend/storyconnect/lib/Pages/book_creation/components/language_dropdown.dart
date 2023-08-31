import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Constants/language_constants.dart';
import 'package:storyconnect/Pages/book_creation/state/book_create_bloc.dart';
import 'package:storyconnect/Widgets/custom_dropdown.dart';

class LanguageDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomDropdown<LanguageConstant>(
      title: "Language",
      initialValue: LanguageConstant.english,
      items: LanguageConstant.values,
      labelBuilder: (lang) => lang.label,
      onSelected: (language) {
        context
            .read<BookCreateBloc>()
            .add(LanguageChangedEvent(language: language.label));
      },
    );
  }
}
