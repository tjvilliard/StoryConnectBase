import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/login/components/layout_constants.dart';
import 'package:storyconnect/Pages/login/state/login_bloc.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({super.key});

  @override
  PasswordState createState() => PasswordState();
}

class PasswordState extends State<PasswordField> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (BuildContext context, LoginState state) {
      final IconData eyeIcon = state.showPassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash;

      return Container(
          constraints: const BoxConstraints(minHeight: 56),
          width: LoginPageConstants.maxWidth,
          padding: LoginPageConstants.verticalPadding,
          child: TextField(
            controller: _passwordController,
            obscureText: !state.showPassword,
            onSubmitted: (_) {
              context.read<LoginBloc>().add(const LoginButtonPushedEvent());
            },
            onChanged: (_) {
              context.read<LoginBloc>().add(PasswordFieldChangedEvent(password: _passwordController.text));
            },
            decoration: InputDecoration(
                errorMaxLines: 2,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                prefixIcon: const Icon(FontAwesomeIcons.lock),
                suffixIcon: IconButton(
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(eyeIcon),
                  ),
                  onPressed: () {
                    context.read<LoginBloc>().add(const ShowPasswordClickedEvent());
                  },
                ),
                labelText: 'Password',
                errorText: state.showPasswordError ? state.passwordError : null),
          ));
    });
  }
}
