import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/writer_profile/state/writer_profile_bloc.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class ProfileCard extends StatelessWidget {
  final Profile profile;
  const ProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 700,
      ),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Aligns children at the start
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    // placeholder for now
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(profile.displayName ?? "No name",
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
              SizedBox(width: 20), // some spacing between columns
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Bio", style: Theme.of(context).textTheme.titleLarge),
                    BlocBuilder<WriterProfileBloc, WriterProfileState>(
                        builder: (context, state) {
                      Widget toReturn;
                      if (state.profileLoadingStruct.isLoading == true) {
                        toReturn = LoadingWidget(
                            loadingStruct: state.profileLoadingStruct);
                      } else {
                        toReturn = Text(state.profile.bio,
                            style: Theme.of(context).textTheme.labelMedium);
                      }
                      return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: toReturn);
                    })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
