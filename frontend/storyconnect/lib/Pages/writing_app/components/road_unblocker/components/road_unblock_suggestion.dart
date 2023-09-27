import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/writing_app/components/road_unblocker/state/road_unblocker_bloc.dart';
import 'package:storyconnect/Widgets/horizontal_divider.dart';

class RoadUnblockerSuggestionWidget extends StatelessWidget {
  final String responseLocalId;
  final RoadUnblockerSuggestion suggestion;
  const RoadUnblockerSuggestionWidget(
      {super.key, required this.responseLocalId, required this.suggestion});

  Widget _boxedResponse(String header, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(header, style: TextStyle(fontStyle: FontStyle.italic)),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(content),
        ),
      ],
    );
  }

  Widget _buildOriginal(String original) {
    return Column(children: [
      SizedBox(height: 15),
      _boxedResponse('Original: ', suggestion.original!),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              suggestion.isAddition() ? 'Add' : 'Replace',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Divider()),
            SizedBox(width: 10),
            Text(suggestion.suggestion),
            if (!suggestion.isAddition()) _buildOriginal(suggestion.original!),
            SizedBox(height: 15),
            _boxedResponse('Suggested:', suggestion.suggestedChange),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton.tonalIcon(
                  onPressed: () {
                    context.read<RoadUnblockerBloc>().add(RejectSuggestionEvent(
                        responseLocalId: responseLocalId,
                        localId: suggestion.uid));
                  },
                  icon: Icon(
                    FontAwesomeIcons.x,
                  ),
                  label: Text(
                    "Reject",
                  ),
                ),
                HorizontalDivider(
                  height: 20,
                ),
                FilledButton.tonalIcon(
                  onPressed: () {
                    context.read<RoadUnblockerBloc>().add(AcceptSuggestionEvent(
                        responseLocalId: responseLocalId,
                        localId: suggestion.uid));
                  },
                  icon: Icon(FontAwesomeIcons.check),
                  label: Text(
                    "Accept",
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
