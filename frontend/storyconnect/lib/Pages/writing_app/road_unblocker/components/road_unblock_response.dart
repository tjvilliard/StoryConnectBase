import 'package:flutter/material.dart';
import 'package:storyconnect/Models/models.dart';

class RoadUnblockResponseWidget extends StatelessWidget {
  final RoadUnblockerResponse response;
  const RoadUnblockResponseWidget({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        child: Column(children: [
          Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                response.message,
                style: Theme.of(context).textTheme.titleMedium,
              )),
          for (final RoadUnblockerSuggestion suggestion in response.suggestions)
            Column(
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      suggestion.suggestion,
                      style: Theme.of(context).textTheme.titleSmall,
                    )),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      suggestion.original,
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .apply(decoration: TextDecoration.lineThrough),
                    )),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      suggestion.replacement,
                      style: Theme.of(context).textTheme.labelMedium,
                    ))
              ],
            )
        ]));
  }
}
