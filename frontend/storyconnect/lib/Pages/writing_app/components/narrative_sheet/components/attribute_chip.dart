import 'package:flutter/material.dart';
import 'package:storyconnect/Constants/confidence_scale.dart';
import 'package:storyconnect/Pages/writing_app/components/narrative_sheet/models/narrative_element_models.dart';

class AttributeChip extends StatelessWidget {
  final NarrativeElementAttribute attribute;
  const AttributeChip({
    super.key,
    required this.attribute,
  });

  @override
  Widget build(BuildContext context) {
    final Color chipColor = confidenceColors[ConfidenceChecker.getConfidence(attribute.confidence)]!;
    const Color textColor = Colors.white;

    final TextStyle textStyle = Theme.of(context).textTheme.labelLarge!.copyWith(
      color: textColor,
      fontStyle: FontStyle.italic,
      shadows: <Shadow>[
        const Shadow(
          offset: Offset(1, 1),
          blurRadius: 2,
          color: Color.fromARGB(255, 111, 111, 111),
        ),
      ],
    );

    return Chip(
      backgroundColor: chipColor,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
              child: Text(
            attribute.attribute,
            style: textStyle,
          )),
          // if (attribute.generated) ...[
          //   const SizedBox(width: 8.0),
          //   Text('${(attribute.confidence * 100).toStringAsFixed(0)}%',
          //       style: textStyle),
          // ],
        ],
      ),
    );
  }
}
