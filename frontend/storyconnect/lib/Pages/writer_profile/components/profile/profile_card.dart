import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/writer_profile/components/profile/bio_text_editor.dart';
import 'package:storyconnect/Pages/writer_profile/components/profile/display_name_editor.dart';
import 'package:storyconnect/Pages/writer_profile/components/profile/edit_bio_button.dart';
import 'package:storyconnect/Pages/writer_profile/components/profile/profile_image.dart';

import 'package:storyconnect/Pages/writer_profile/state/writer_profile_bloc.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class ProfileCard extends StatefulWidget {
  final String uid;
  const ProfileCard({super.key, required this.uid});

  @override
  ProfileCardState createState() => ProfileCardState();
}

class ProfileCardState extends State<ProfileCard> {
  String get uid => widget.uid;
  bool? _showEditProfile;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final loggedInId = FirebaseAuth.instance.currentUser?.uid;
      if (loggedInId != null && loggedInId == uid) {
        setState(() {
          _showEditProfile = true;
        });
      } else {
        setState(() {
          _showEditProfile = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 700,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start, // Aligns children at the start
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const ProfileImage(),
                  const SizedBox(height: 8),
                  BlocBuilder<WriterProfileBloc, WriterProfileState>(
                    builder: (context, state) {
                      Widget toReturn;
                      if (state.loadingStructs.profileLoadingStruct.isLoading == true) {
                        return Container();
                      } else if (state.isEditingBio) {
                        toReturn = const DisplayNameEditor();
                      } else {
                        toReturn = Text(state.profile.displayName, style: Theme.of(context).textTheme.titleMedium);
                      }
                      return AnimatedSwitcher(duration: const Duration(milliseconds: 500), child: toReturn);
                    },
                  )
                ],
              ),
              const SizedBox(width: 20), // some spacing between columns
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Bio", style: Theme.of(context).textTheme.titleLarge),
                    BlocBuilder<WriterProfileBloc, WriterProfileState>(builder: (context, state) {
                      Widget toReturn;
                      if (state.loadingStructs.profileLoadingStruct.isLoading == true) {
                        toReturn = Row(
                          key: const ValueKey('loading'),
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [LoadingWidget(loadingStruct: state.loadingStructs.profileLoadingStruct)],
                        );
                      } else if (state.isEditingBio) {
                        toReturn = const BioTextEditor();
                      } else {
                        toReturn = Text(state.profile.bio, style: Theme.of(context).textTheme.labelLarge);
                      }
                      return Padding(
                          padding: const EdgeInsets.all(10),
                          child: AnimatedSwitcher(duration: const Duration(milliseconds: 500), child: toReturn));
                    })
                  ],
                ),
              ),
              BlocBuilder<WriterProfileBloc, WriterProfileState>(buildWhen: (previous, current) {
                return previous.isEditingBio != current.isEditingBio;
              }, builder: (context, state) {
                Widget toReturn;
                if (_showEditProfile == true && state.isEditingBio == false) {
                  toReturn = const Column(
                    key: ValueKey('edit_profile_button'),
                    children: [EditProfileButton()],
                  );
                } else {
                  toReturn = const SizedBox(
                    width: 40,
                    key: ValueKey('empty_space'),
                  );
                }

                return AnimatedSwitcher(duration: const Duration(milliseconds: 500), child: toReturn);
              })
            ],
          ),
        ),
      ),
    );
  }
}
