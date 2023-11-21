import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/login/components/layout_constants.dart';
import 'package:storyconnect/Pages/registration/state/register_bloc.dart';

class ConfirmPasswordField extends StatefulWidget {
  const ConfirmPasswordField({super.key});

  @override
  ConfirmPasswordState createState() => ConfirmPasswordState();
}

class ConfirmPasswordState extends State<ConfirmPasswordField> {
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(builder: (BuildContext context, RegistrationState state) {
      final IconData eyeIcon = state.showPassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash;
      return Container(
          constraints: const BoxConstraints(minHeight: 56),
          width: LoginPageConstants.maxWidth,
          padding: LoginPageConstants.verticalPadding,
          child: TextField(
            controller: _confirmPasswordController,
            obscureText: !state.showConfirmPassword,
            onChanged: (_) {
              context
                  .read<RegistrationBloc>()
                  .add(PasswordConfirmFieldChangedEvent(confirmPassword: _confirmPasswordController.text));
            },
            decoration: InputDecoration(
                errorMaxLines: 3,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                prefixIcon: const Icon(FontAwesomeIcons.lock),
                suffixIcon: IconButton(
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(eyeIcon),
                  ),
                  onPressed: () {
                    context.read<RegistrationBloc>().add(ShowPasswordConfirmClickedEvent());
                  },
                ),
                labelText: 'Confirm Password',
                errorText: state.showConfirmPasswordError ? state.confirmPasswordError : null),
          ));
    });
  }
}
