import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/writer_profile/state/writer_profile_bloc.dart';

class EditProfileImageDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Stack(children: [
      Container(
        constraints: BoxConstraints(maxWidth: 550, minHeight: 500),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Profile Image", style: Theme.of(context).textTheme.displaySmall),
                SizedBox(width: 15),
                Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Icon(FontAwesomeIcons.user, size: 25, color: Theme.of(context).colorScheme.secondary))
              ],
            ),
            BlocBuilder<WriterProfileBloc, WriterProfileState>(
              builder: (context, state) {
                Widget toReturn;
                if (state.tempProfileImage != null) {
                  toReturn = Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
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
                          padding: EdgeInsets.all(50),
                          child: Column(
                            children: [
                              FilledButton.icon(
                                  onPressed: () async {
                                    context.read<WriterProfileBloc>().add(SelectProfileImageEvent());
                                  },
                                  icon: Icon(FontAwesomeIcons.upload),
                                  label: Text("Upload Image")),
                              SizedBox(height: 15),
                              Text("or", style: Theme.of(context).textTheme.titleMedium),
                              SizedBox(height: 15),
                              FilledButton.tonalIcon(
                                  onPressed: () async {
                                    bool confirm = await showConfirmationDialog(context);
                                    if (confirm) {
                                      context.read<WriterProfileBloc>().add(DeleteProfileImageEvent());
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  icon: Icon(FontAwesomeIcons.x),
                                  label: Text(" Delete Current Image")),
                            ],
                          )));
                }
                return AnimatedContainer(duration: Duration(milliseconds: 500), child: toReturn);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton.tonal(
                  onPressed: () {
                    context.read<WriterProfileBloc>().add(ClearProfileImageEvent());
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel"),
                ),
                SizedBox(width: 10),
                FilledButton.icon(
                  onPressed: () {
                    context.read<WriterProfileBloc>().add(SaveProfileImageEvent());
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.save,
                    color: Theme.of(context).colorScheme.surfaceVariant,
                  ),
                  label: Text("Save"),
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
            context.read<WriterProfileBloc>().add(ClearProfileImageEvent());
            Navigator.of(context).pop();
          },
          icon: Icon(FontAwesomeIcons.x),
        ),
      ),
    ]));
  }

  Future<bool> showConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Are you sure?"),
        content: Text("This will delete your current profile image"),
        actions: [
          TextButton(
            child: Text("No"),
            onPressed: () => Navigator.of(context).pop(false), // passing 'false' when No is pressed
          ),
          TextButton(
            child: Text("Yes"),
            onPressed: () => Navigator.of(context).pop(true), // passing 'true' when Yes is pressed
          ),
        ],
      ),
    );

    return result ?? false; // Return false if the dialog is dismissed
  }
}
