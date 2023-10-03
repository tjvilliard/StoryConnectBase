import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/writing_app/components/narrative_sheet/models/narrative_element_models.dart';

class NarrativeElementCard extends StatelessWidget {
  const NarrativeElementCard({
    Key? key,
    required this.narrativeElement,
  }) : super(key: key);

  final NarrativeElement narrativeElement;

  @override
  Widget build(BuildContext context) {
    return Card(child: Text("Hello"));
  }
}
