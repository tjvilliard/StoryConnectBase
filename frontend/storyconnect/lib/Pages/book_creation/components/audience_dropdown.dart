import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Constants/target_audience_constants.dart';
import 'package:storyconnect/Pages/book_creation/state/book_create_bloc.dart';
import 'package:storyconnect/Widgets/custom_dropdown.dart';

class AudienceDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomDropdown<TargetAudience>(
      title: "Target Audience",
      initialValue: TargetAudience.youngAdult,
      items: TargetAudience.values,
      labelBuilder: (lang) => lang.label,
      onSelected: (audience) {
        context
            .read<BookCreateBloc>()
            .add(TargetAudienceChangedEvent(targetAudience: audience));
      },
    );
  }
}
