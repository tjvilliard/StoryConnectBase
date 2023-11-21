import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/writing_app/components/narrative_sheet/components/attributes.dart';
import 'package:storyconnect/Pages/writing_app/components/narrative_sheet/models/narrative_element_models.dart';

class NarrativeElementCard extends StatelessWidget {
  final NarrativeElement narrativeElement;

  const NarrativeElementCard({
    super.key,
    required this.narrativeElement,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    flex: 2,
                    child: Container(
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: Card(
                            elevation: .5,
                            child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    const Placeholder(
                                      fallbackHeight: 100,
                                      fallbackWidth: 100,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(narrativeElement.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(narrativeElement.description ??
                                        "No description provided.")
                                  ],
                                ))))),
                const SizedBox(width: 10),
                Flexible(
                    flex: 3,
                    child: AttributesWidget(
                        attributes: narrativeElement.sortedAttributes))
              ],
            )));
  }
}
