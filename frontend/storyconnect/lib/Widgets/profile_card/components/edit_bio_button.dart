import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Widgets/profile_card/state/profile_card_bloc.dart';

class EditProfileButton extends StatelessWidget {
  const EditProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
        onPressed: () {
          context.read<ProfileCardBloc>().add(const EditProfileEvent());
        },
        icon: const Icon(FontAwesomeIcons.pencil));
  }
}
