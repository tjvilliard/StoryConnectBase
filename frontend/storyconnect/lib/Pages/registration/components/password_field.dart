import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/login/components/layout_constants.dart';
import 'package:storyconnect/Pages/registration/state/register_bloc.dart';

class PasswordField extends StatefulWidget {
  const PasswordField();

  @override
  _passwordState createState() => _passwordState();
}

class _passwordState extends State<PasswordField> {
  final TextEditingController _passwordController = TextEditingController();

  _passwordState();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    this._passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
        builder: (BuildContext context, RegistrationState state) {
      final IconData eyeIcon =
          state.showPassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash;
      return Container(
          constraints: BoxConstraints(minHeight: 56),
          width: LoginPageConstants.maxWidth,
          padding: LoginPageConstants.verticalPadding,
          child: TextField(
            controller: this._passwordController,
            obscureText: !state.showPassword,
            onChanged: (_) {
              context.read<RegistrationBloc>().add(PasswordFieldChangedEvent(
                  password: this._passwordController.text));
            },
            decoration: InputDecoration(
                errorMaxLines: 3,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                prefixIcon: Icon(Icons.lock_rounded),
                suffixIcon: IconButton(
                  icon: Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Icon(eyeIcon),
                  ),
                  onPressed: () {
                    context
                        .read<RegistrationBloc>()
                        .add(ShowPasswordClickedEvent());
                  },
                ),
                labelText: 'Password',
                errorText:
                    state.showPasswordError ? state.passwordError : null),
          ));
    });
  }
}
