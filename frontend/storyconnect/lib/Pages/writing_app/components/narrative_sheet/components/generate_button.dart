import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/narrative_sheet/state/narrative_sheet_bloc.dart';

class GenerateNarrativeSheetButton extends StatelessWidget {
  final String text;
  const GenerateNarrativeSheetButton(
    this.text, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
        onPressed: () {
          context.read<NarrativeSheetBloc>().add(const GenerateNarrativeSheet());
        },
        child: Text(text));
  }
}
