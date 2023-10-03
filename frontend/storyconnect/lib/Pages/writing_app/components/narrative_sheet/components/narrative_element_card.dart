import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/writing_app/components/narrative_sheet/components/attributes.dart';
import 'package:storyconnect/Pages/writing_app/components/narrative_sheet/models/narrative_element_models.dart';

class NarrativeElementCard extends StatelessWidget {
  final NarrativeElement narrativeElement;

  const NarrativeElementCard({
    Key? key,
    required this.narrativeElement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(16),
        child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        Placeholder(
                          fallbackHeight: 50,
                          fallbackWidth: 50,
                        ),
                        SizedBox(width: 10),
                        Text(narrativeElement.name,
                            style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(narrativeElement.description ??
                        "No description provided."),
                  ],
                ),
                SizedBox(height: 10),
                AttributesWidget(attributes: narrativeElement.sortedAttributes)
              ],
            )));
  }
}
