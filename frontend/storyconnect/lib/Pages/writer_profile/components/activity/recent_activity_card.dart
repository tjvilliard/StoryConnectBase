import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writer_profile/models/writer_profile_models.dart';
import 'package:storyconnect/Pages/writer_profile/state/writer_profile_bloc.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

part 'activity_card.dart';

class RecentActivityCard extends StatelessWidget {
  const RecentActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
            constraints: BoxConstraints(maxWidth: 230),
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  "Recent Activity",
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 20),
                BlocBuilder<WriterProfileBloc, WriterProfileState>(
                    builder: (context, state) {
                  Widget toReturn;
                  if (state.loadingStructs.activitiesLoadingStruct.isLoading ==
                      true) {
                    toReturn = LoadingWidget(
                        loadingStruct:
                            state.loadingStructs.activitiesLoadingStruct);
                  } else {
                    if (state.activities.isEmpty) {
                      toReturn = Text("No activity found");
                    } else {
                      toReturn = ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: state.activities.length,
                          itemBuilder: (context, index) {
                            return _ActivityCard(
                                activity: state.activities[index]);
                          });
                    }
                  }
                  return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: toReturn);
                })
              ],
            )));
  }
}
