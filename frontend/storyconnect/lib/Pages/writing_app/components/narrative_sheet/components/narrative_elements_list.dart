import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/writing_app/components/narrative_sheet/components/generate_button.dart';
import 'package:storyconnect/Pages/writing_app/components/narrative_sheet/components/narrative_element_card.dart';
import 'package:storyconnect/Pages/writing_app/components/narrative_sheet/models/narrative_element_models.dart';

class NarrativeElementsList extends StatelessWidget {
  final List<NarrativeElement> narrativeElements;
  final bool triedToGenerate;
  const NarrativeElementsList({super.key, required this.narrativeElements, required this.triedToGenerate});

  @override
  Widget build(BuildContext context) {
    if (narrativeElements.isEmpty) {
      return Container(
          alignment: Alignment.topCenter,
          child: Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!triedToGenerate) const Text('No narrative elements available.'),
                      if (triedToGenerate)
                        const Text("No narrative elements were found. Try writing some text and trying again."),
                      const SizedBox(height: 20),
                      const GenerateNarrativeSheetButton('Generate Narrative Sheet')
                    ],
                  ))));
    }

    return ListView.separated(
      itemCount: narrativeElements.length + 1,
      separatorBuilder: (context, index) {
        final element = narrativeElements[index];

        if (index == narrativeElements.length - 1) {
          return const SizedBox.shrink();
        } else if (narrativeElements[index + 1].elementType != element.elementType) {
          return const SizedBox(
            height: 20,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
      itemBuilder: (context, index) {
        if (index == narrativeElements.length) {
          return const Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [GenerateNarrativeSheetButton('Regenerate Narrative Sheet')],
              ));
        }
        final element = narrativeElements[index];

        if (index == 0 || narrativeElements[index - 1].elementType != element.elementType) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    element.elementType.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              NarrativeElementCard(narrativeElement: element)
            ],
          );
        }
        // add the 'regenerate' button to the end of the list
        else {
          return NarrativeElementCard(narrativeElement: element);
        }
      },
    );
  }
}
