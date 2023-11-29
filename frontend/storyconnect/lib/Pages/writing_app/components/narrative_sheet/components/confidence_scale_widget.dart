import 'package:flutter/material.dart';
import 'package:storyconnect/Constants/confidence_scale.dart';

class ConfidenceScale extends StatelessWidget {
  const ConfidenceScale({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle =
        Theme.of(context).textTheme.labelLarge!.copyWith(
      color: Colors.white,
      fontStyle: FontStyle.italic,
      shadows: <Shadow>[
        const Shadow(
          offset: Offset(1, 1),
          blurRadius: 2,
          color: Color.fromARGB(255, 111, 111, 111),
        ),
      ],
    );

    return Column(children: [
      Text("Confidence Scale", style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 5),
      Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: confidenceColors.entries.map((entry) {
          bool isFirst = entry.key == confidenceColors.keys.first;
          bool isLast = entry.key == confidenceColors.keys.last;

          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: entry.value,
              borderRadius: BorderRadius.only(
                topLeft: isFirst ? const Radius.circular(10.0) : Radius.zero,
                topRight: isLast ? const Radius.circular(10.0) : Radius.zero,
                bottomLeft: isFirst ? const Radius.circular(10.0) : Radius.zero,
                bottomRight: isLast ? const Radius.circular(10.0) : Radius.zero,
              ),
            ),
            width: 100, // Adjust width if necessary
            height: 30, // Adjust height if necessary
            child: Text(entry.key.description,
                textAlign: TextAlign.center,
                style: textStyle), // Assuming white text on colored backgrounds
          );
        }).toList(),
      )
    ]);
  }
}
