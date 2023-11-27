import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:storyconnect/Repositories/core_repository.dart';
import 'package:storyconnect/Widgets/loading_widget.dart';
import 'package:storyconnect/Widgets/profile_card/components/bio_text_editor.dart';
import 'package:storyconnect/Widgets/profile_card/components/display_name_editor.dart';
import 'package:storyconnect/Widgets/profile_card/components/edit_bio_button.dart';
import 'package:storyconnect/Widgets/profile_card/components/expandable_bio.dart';
import 'package:storyconnect/Widgets/profile_card/components/profile_image.dart';
import 'package:storyconnect/Widgets/profile_card/state/profile_card_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileCardWidget extends StatefulWidget {
  final String uid;
  final bool forceNoEdit;
  const ProfileCardWidget({super.key, required this.uid, this.forceNoEdit = false});

  @override
  ProfileCardWidgetState createState() => ProfileCardWidgetState();
}

class ProfileCardWidgetState extends State<ProfileCardWidget> {
  String get uid => widget.uid;
  bool? _showEditProfile;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final loggedInId = FirebaseAuth.instance.currentUser?.uid;
      if (loggedInId != null && loggedInId == uid && widget.forceNoEdit == false) {
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
    return BlocProvider<ProfileCardBloc>(
        create: (context) => ProfileCardBloc(context.read<CoreRepository>(), uid),
        child: Builder(
            builder: (context) => BlocListener<ProfileCardBloc, ProfileCardState>(
                listenWhen: (previous, current) => previous.responseMessages != current.responseMessages,
                listener: (context, state) {
                  if (state.responseMessages.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.responseMessages.last), duration: const Duration(seconds: 6)));
                    // clear the messages
                    context.read<ProfileCardBloc>().add(const ClearShownResponseEvent());
                  }
                },
                child: ConstrainedBox(
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
                              BlocBuilder<ProfileCardBloc, ProfileCardState>(
                                builder: (context, state) {
                                  Widget toReturn;
                                  if (state.loadingStruct.isLoading == true) {
                                    return Container();
                                  } else if (state.isEditing) {
                                    toReturn = const DisplayNameEditor();
                                  } else {
                                    toReturn =
                                        Text(state.profile.displayName, style: Theme.of(context).textTheme.titleMedium);
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
                                BlocBuilder<ProfileCardBloc, ProfileCardState>(builder: (context, state) {
                                  Widget toReturn;
                                  if (state.loadingStruct.isLoading == true) {
                                    toReturn = Row(
                                      key: const ValueKey('loading'),
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [LoadingWidget(loadingStruct: state.loadingStruct)],
                                    );
                                  } else if (state.isEditing) {
                                    toReturn = const BioTextEditor();
                                  } else {
                                    toReturn = ExpandableBioWidget(
                                      bioText: state.profile.bio,
                                    );
                                  }
                                  return Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: AnimatedSwitcher(
                                          duration: const Duration(milliseconds: 500), child: toReturn));
                                })
                              ],
                            ),
                          ),
                          BlocBuilder<ProfileCardBloc, ProfileCardState>(buildWhen: (previous, current) {
                            return previous.isEditing != current.isEditing;
                          }, builder: (context, state) {
                            Widget toReturn;
                            if (_showEditProfile == true && state.isEditing == false) {
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
                ))));
  }
}
