import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/writing_app/components/narrative_sheet/components/narrative_element_card.dart';
import 'package:storyconnect/Pages/writing_app/components/narrative_sheet/models/narrative_element_models.dart';

class NarrativeElementsList extends StatelessWidget {
  final List<NarrativeElement> narrativeElements;
  const NarrativeElementsList({Key? key, required this.narrativeElements});

  @override
  Widget build(BuildContext context) {
    if (narrativeElements.isEmpty) {
      return Center(child: Text('No narrative elements available.'));
    }

    return ListView.separated(
        itemCount: narrativeElements.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          final element = narrativeElements[index];
          if (index == 0 ||
              narrativeElements[index - 1].elementType != element.elementType) {
            return Column(
              children: [
                Text(element.elementType.name),
                NarrativeElementCard(narrativeElement: element)
              ],
            );
          } else {
            return NarrativeElementCard(narrativeElement: element);
          }
        });
  }
}
