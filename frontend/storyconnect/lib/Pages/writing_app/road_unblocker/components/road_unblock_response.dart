import 'package:flutter/material.dart';
import 'package:storyconnect/Models/models.dart';

class RoadUnblockResponseWidget extends StatelessWidget {
  final RoadUnblockerResponse response;
  const RoadUnblockResponseWidget({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              response.message,
              style: Theme.of(context).textTheme.titleSmall,
            )));
  }
}
