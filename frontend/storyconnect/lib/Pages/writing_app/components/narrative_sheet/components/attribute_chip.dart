import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/writing_app/components/narrative_sheet/models/narrative_element_models.dart';

class AttributeChip extends StatelessWidget {
  final NarrativeElementAttribute attribute;
  const AttributeChip({
    super.key,
    required this.attribute,
  });

  @override
  Widget build(BuildContext context) {
    // Convert confidence to alpha value (0 to 255).
    int alpha = (attribute.confidence * 255).toInt().clamp(0, 255);

    // Use a different base color. For example, a shade of blue.
    Color chipColor = Theme.of(context).colorScheme.primary.withAlpha(alpha);

    // Modify text color based on the alpha of the chip.
    // Here, if alpha is low (less confident), text is darker for better contrast.
    Color textColor = alpha < 127 ? Colors.black : Colors.white;

    return Chip(
      backgroundColor: chipColor,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            attribute.attribute,
            style: TextStyle(color: textColor),
          ),
          if (attribute.generated) ...[
            SizedBox(width: 8.0),
            Text(
              '${(attribute.confidence * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                color: textColor,
                fontSize: 12.0,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
