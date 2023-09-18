import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Constants/copyright_constants.dart';
import 'package:storyconnect/Pages/book_creation/state/book_create_bloc.dart';
import 'package:storyconnect/Widgets/custom_dropdown.dart';

class CopyrightDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomDropdown<CopyrightOption>(
      title: "Copyright Options",
      initialValue: CopyrightOption.allRightsReserved,
      items: CopyrightOption.values,
      labelBuilder: (copy) => copy.description,
      onSelected: (option) {
        context
            .read<BookCreateBloc>()
            .add(CopyrightChangedEvent(copyrightOption: option));
      },
    );
  }
}
