import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/writing_app/components/narrative_sheet/components/narrative_element_card.dart';
import 'package:storyconnect/Pages/writing_app/components/narrative_sheet/models/narrative_element_models.dart';

class NarrativeElementsList extends StatelessWidget {
  final List<NarrativeElement> narrativeElements;
  const NarrativeElementsList({Key? key, required this.narrativeElements});

  @override
  Widget build(BuildContext context) {
    if (narrativeElements.isEmpty) {
      return Center(
          child: Card(
              margin: EdgeInsets.all(16),
              child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No narrative elements available.'))));
    }

    return ListView.separated(
      itemCount: narrativeElements.length,
      separatorBuilder: (context, index) {
        final element = narrativeElements[index];

        if (index == narrativeElements.length - 1) {
          return SizedBox.shrink();
        } else if (narrativeElements[index + 1].elementType !=
            element.elementType) {
          return SizedBox(
            height: 20,
          );
        } else {
          return SizedBox.shrink();
        }
      },
      itemBuilder: (context, index) {
        final element = narrativeElements[index];

        if (index == 0 ||
            narrativeElements[index - 1].elementType != element.elementType) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "${element.elementType.name}s",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              NarrativeElementCard(narrativeElement: element)
            ],
          );
        } else {
          return NarrativeElementCard(narrativeElement: element);
        }
      },
    );
  }
}
