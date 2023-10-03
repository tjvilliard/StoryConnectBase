import 'package:flutter/widgets.dart';
import 'package:storyconnect/Pages/writing_app/components/narrative_sheet/components/attribute_chip.dart';
import 'package:storyconnect/Pages/writing_app/components/narrative_sheet/models/narrative_element_models.dart';

class AttributesWidget extends StatelessWidget {
  final List<NarrativeElementAttribute> attributes;
  const AttributesWidget({super.key, required this.attributes});

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];
    List<Widget> currentRowItems = [];

    for (int i = 0; i < attributes.length; i++) {
      currentRowItems.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: AttributeChip(attribute: attributes[i]),
        ),
      );

      // Check if it's the last item or if the next item has a different type
      if (i == attributes.length - 1 ||
          attributes[i].attributeType != attributes[i + 1].attributeType) {
        currentRowItems.insert(0, Text(attributes[i].attributeType.name + ":"));
        rows.add(Row(
          mainAxisSize: MainAxisSize.min,
          children: currentRowItems,
        ));
        rows.add(SizedBox(height: 10)); // Add spacing between rows
        currentRowItems = [];
      }
    }

    return Column(
      children: rows,
    );
  }
}
