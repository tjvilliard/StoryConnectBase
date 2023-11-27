import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Widgets/profile_card/state/profile_card_bloc.dart';

class EditProfileImageDialog extends StatelessWidget {
  const EditProfileImageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Stack(children: [
      Container(
        constraints: const BoxConstraints(maxWidth: 550, minHeight: 500),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Profile Image", style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(width: 15),
                Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Icon(FontAwesomeIcons.user, size: 25, color: Theme.of(context).colorScheme.secondary))
              ],
            ),
            BlocBuilder<ProfileCardBloc, ProfileCardState>(
              builder: (context, state) {
                Widget toReturn;
                if (state.tempProfileImage != null) {
                  toReturn = Container(
                    width: 300,
                    height: 300,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.memory(
                        state.tempProfileImage!,
                        fit: BoxFit.cover, // This will ensure the image covers the entire circle
                      ),
                    ),
                  );
                } else {
                  toReturn = Card(
                      child: Padding(
                          padding: const EdgeInsets.all(50),
                          child: Column(
                            children: [
                              FilledButton.icon(
                                  onPressed: () async {
                                    context.read<ProfileCardBloc>().add(const SelectProfileImageEvent());
                                  },
                                  icon: const Icon(FontAwesomeIcons.upload),
                                  label: const Text("Upload Image")),
                              const SizedBox(height: 15),
                              Text("or", style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 15),
                              FilledButton.tonalIcon(
                                  onPressed: () async {
                                    bool confirm = await showConfirmationDialog(context);
                                    if (confirm) {
                                      // ignore: use_build_context_synchronously
                                      context.read<ProfileCardBloc>().add(const DeleteProfileImageEvent());
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  icon: const Icon(FontAwesomeIcons.x),
                                  label: const Text(" Delete Current Image")),
                            ],
                          )));
                }
                return AnimatedContainer(duration: const Duration(milliseconds: 500), child: toReturn);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton.tonal(
                  onPressed: () {
                    context.read<ProfileCardBloc>().add(const ClearProfileImageEvent());
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),
                const SizedBox(width: 10),
                FilledButton.icon(
                  onPressed: () {
                    context.read<ProfileCardBloc>().add(const SaveProfileImageEvent());
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.save,
                    color: Theme.of(context).colorScheme.surfaceVariant,
                  ),
                  label: const Text("Save"),
                ),
              ],
            )
          ],
        ),
      ),
      Positioned(
        top: 15,
        right: 20,
        child: IconButton.filledTonal(
          onPressed: () {
            context.read<ProfileCardBloc>().add(const ClearProfileImageEvent());
            Navigator.of(context).pop();
          },
          icon: const Icon(FontAwesomeIcons.x),
        ),
      ),
    ]));
  }

  Future<bool> showConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure?"),
        content: const Text("This will delete your current profile image"),
        actions: [
          TextButton(
            child: const Text("No"),
            onPressed: () => Navigator.of(context).pop(false), // passing 'false' when No is pressed
          ),
          TextButton(
            child: const Text("Yes"),
            onPressed: () => Navigator.of(context).pop(true), // passing 'true' when Yes is pressed
          ),
        ],
      ),
    );

    return result ?? false; // Return false if the dialog is dismissed
  }
}
