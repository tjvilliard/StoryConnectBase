import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/writing_app/components/continuity_checker/components/continuity_card.dart';
import 'package:storyconnect/Pages/writing_app/components/continuity_checker/models/continuity_models.dart';

class ContinuityList extends StatefulWidget {
  final List<ContinuitySuggestion> continuities;

  const ContinuityList({super.key, required this.continuities});

  @override
  ContinuityListState createState() => ContinuityListState();
}

class ContinuityListState extends State<ContinuityList> {
  @override
  Widget build(BuildContext context) {
    if (widget.continuities.isEmpty) {
      return const Column(children: [
        Card(
            child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                    "No Continuity Errors were found. Try clicking the button below to see if any continuity errors can be found!")))
      ]);
    }

    return ListView.builder(
      itemCount: widget.continuities.length,
      itemBuilder: (context, index) {
        final continuity = widget.continuities[index];
        return ContinuityCard(continuity: continuity);
      },
    );
  }
}
