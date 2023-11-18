import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/writer_profile/state/writer_profile_bloc.dart';

class EditBioButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
        onPressed: () {
          context.read<WriterProfileBloc>().add(EditBioEvent());
        },
        icon: Icon(FontAwesomeIcons.pencil));
  }
}
