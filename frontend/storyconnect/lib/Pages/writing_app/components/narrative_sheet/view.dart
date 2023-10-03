import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writing_app/components/narrative_sheet/components/narrative_elements_list.dart';
import 'package:storyconnect/Pages/writing_app/components/narrative_sheet/state/narrative_sheet_bloc.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class NarrativeSheetView extends StatelessWidget {
  const NarrativeSheetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Narrative Element Sheet',
            style: Theme.of(context).textTheme.displayMedium),
        BlocBuilder<NarrativeSheetBloc, NarrativeSheetState>(
            builder: (context, state) {
          Widget toReturn;

          if (state.loading.isLoading) {
            toReturn = LoadingWidget(loadingStruct: state.loading);
          } else {
            toReturn = NarrativeElementsList(
                narrativeElements: state.sortedNarrativeElements);
          }
          return AnimatedSwitcher(
              duration: Duration(milliseconds: 200), child: toReturn);
        })
      ],
    );
  }
}
