import 'package:flutter/material.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/writing_app/components/road_unblocker/components/road_unblock_suggestion.dart';

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
            Column(children: [
              RoadUnblockerSuggestionWidget(
                  responseLocalId: response.localId, suggestion: suggestion),
              // don't add if it's the last suggestion
              if (suggestion != response.suggestions.last)
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Divider())
            ])
        ]));
  }
}
