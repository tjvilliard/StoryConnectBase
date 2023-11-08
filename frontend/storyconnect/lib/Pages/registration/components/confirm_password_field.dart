import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/login/components/layout_constants.dart';
import 'package:storyconnect/Pages/registration/state/register_bloc.dart';

class ConfirmPasswordField extends StatefulWidget {
  const ConfirmPasswordField();

  @override
  _confirmPasswordState createState() => _confirmPasswordState();
}

class _confirmPasswordState extends State<ConfirmPasswordField> {
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
        builder: (BuildContext context, RegistrationState state) {
      return Container(
          constraints: BoxConstraints(minHeight: 56),
          width: LoginPageConstants.maxWidth,
          padding: LoginPageConstants.verticalPadding,
          child: TextField(
            controller: this._confirmPasswordController,
            obscureText: !state.showConfirmPassword,
            onChanged: (_) {
              context.read<RegistrationBloc>().add(
                  PasswordConfirmFieldChangedEvent(
                      confirmPassword: this._confirmPasswordController.text));
            },
            decoration: InputDecoration(
                errorMaxLines: 3,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                prefixIcon: Icon(FontAwesomeIcons.lock),
                suffixIcon: IconButton(
                  icon: state.showConfirmPassword
                      ? Icon(FontAwesomeIcons.eye)
                      : Icon(FontAwesomeIcons.eyeSlash),
                  onPressed: () {
                    context
                        .read<RegistrationBloc>()
                        .add(ShowPasswordConfirmClickedEvent());
                  },
                ),
                labelText: 'Confirm Password',
                errorText: state.showConfirmPasswordError
                    ? state.confirmPasswordError
                    : null),
          ));
    });
  }
}
