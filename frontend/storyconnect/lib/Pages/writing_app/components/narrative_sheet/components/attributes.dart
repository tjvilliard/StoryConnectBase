import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/writing_app/components/narrative_sheet/components/attribute_chip.dart';
import 'package:storyconnect/Pages/writing_app/components/narrative_sheet/models/narrative_element_models.dart';

class AttributesWidget extends StatelessWidget {
  final List<NarrativeElementAttribute> attributes;
  const AttributesWidget({super.key, required this.attributes});

  List<Widget> buildTitle(BuildContext context) {
    List<Widget> toReturn = [];

    toReturn.add(Row(
      children: [
        Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              "Attributes",
              style: Theme.of(context).textTheme.titleLarge,
            ))
      ],
    ));

    toReturn.add(const Divider());

    toReturn.add(const SizedBox(height: 10));

    return toReturn;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = buildTitle(context);
    List<Widget> currentRowItems = [];

    for (int i = 0; i < attributes.length; i++) {
      currentRowItems.add(
        AttributeChip(attribute: attributes[i]),
      );

      // Check if it's the last item or if the next item has a different type
      if (i == attributes.length - 1 ||
          attributes[i].attributeType != attributes[i + 1].attributeType) {
        rows.add(Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(attributes[i].attributeType.name,
                style: Theme.of(context).textTheme.titleMedium)));
        rows.add(const SizedBox(height: 5));
        rows.add(Padding(
            padding: const EdgeInsets.only(top: 2.5, bottom: 2.5, left: 15, right: 5),
            child: Wrap(
              spacing: 5,
              runSpacing: 5,
              children: currentRowItems,
            )));

        rows.add(const SizedBox(height: 20));

        currentRowItems = [];
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }
}
