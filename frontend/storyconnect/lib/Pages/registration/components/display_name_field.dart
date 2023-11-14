import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/login/components/layout_constants.dart';
import 'package:storyconnect/Pages/registration/state/register_bloc.dart';

class DisplayNameField extends StatefulWidget {
  @override
  _displayNameState createState() => _displayNameState();
}

class _displayNameState extends State<DisplayNameField> {
  final TextEditingController _displayNameController = TextEditingController();

  @override
  void dispose() {
    this._displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      builder: (BuildContext context, RegistrationState state) {
        return Container(
            constraints: BoxConstraints(minHeight: 56),
            width: LoginPageConstants.maxWidth,
            padding: LoginPageConstants.verticalPadding,
            child: TextField(
                controller: this._displayNameController,
                obscureText: false,
                onChanged: (_) {},
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: Icon(FontAwesomeIcons.pen),
                    labelText: 'Display Name',
                    errorText: null)));
      },
    );
  }
}
