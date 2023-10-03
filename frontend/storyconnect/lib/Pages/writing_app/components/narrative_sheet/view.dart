import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/narrative_sheet/state/narrative_sheet_bloc.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class NarrativeSheetView extends StatelessWidget {
  const NarrativeSheetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Character Sheet',
            style: Theme.of(context).textTheme.displayMedium),
        BlocBuilder<NarrativeSheetBloc, NarrativeSheetState>(
            builder: (context, state) {
          Widget toReturn;

          if (state.loading.isLoading) {
            toReturn = LoadingWidget(loadingStruct: state.loading);
          } else {
            toReturn = Card(child: Text("Johny"));
          }
          return AnimatedSwitcher(
              duration: Duration(milliseconds: 200), child: toReturn);
        })
      ],
    );
  }
}
