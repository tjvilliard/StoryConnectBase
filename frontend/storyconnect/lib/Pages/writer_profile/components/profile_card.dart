import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Models/models.dart';
import 'package:storyconnect/Pages/writer_profile/components/bio_text_editor.dart';
import 'package:storyconnect/Pages/writer_profile/components/edit_bio_button.dart';
import 'package:storyconnect/Pages/writer_profile/state/writer_profile_bloc.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';

class ProfileCard extends StatefulWidget {
  final Profile profile;
  final String uid;
  const ProfileCard({super.key, required this.profile, required this.uid});

  @override
  ProfileCardState createState() => ProfileCardState();
}

class ProfileCardState extends State<ProfileCard> {
  String get uid => widget.uid;
  Profile get profile => widget.profile;
  bool? _showEditProfile = null;

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
                      if (state.loadingStructs.profileLoadingStruct.isLoading ==
                          true) {
                        toReturn = Row(
                          key: ValueKey('loading'),
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LoadingWidget(
                                loadingStruct:
                                    state.loadingStructs.profileLoadingStruct)
                          ],
                        );
                      } else if (state.isEditingBio) {
                        toReturn = Padding(
                            key: ValueKey('bio_editor'),
                            padding: EdgeInsets.all(10),
                            child: BioTextEditor());
                      } else {
                        toReturn = Padding(
                            key: ValueKey('bio_text'),
                            padding: EdgeInsets.all(10),
                            child: Text(state.profile.bio,
                                style: Theme.of(context).textTheme.labelLarge));
                      }
                      return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: toReturn);
                    })
                  ],
                ),
              ),
              BlocBuilder<WriterProfileBloc, WriterProfileState>(
                  buildWhen: (previous, current) {
                return previous.isEditingBio != current.isEditingBio;
              }, builder: (context, state) {
                Widget toReturn;
                if (_showEditProfile == true && state.isEditingBio == false) {
                  toReturn = Column(
                    key: ValueKey('edit_bio_button'),
                    children: [EditBioButton()],
                  );
                } else {
                  toReturn = SizedBox(
                    width: 40,
                    key: ValueKey('empty_space'),
                  );
                }

                return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: toReturn);
              })
            ],
          ),
        ),
      ),
    );
  }
}
