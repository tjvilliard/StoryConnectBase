import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/login/components/layout_constants.dart';
import 'package:storyconnect/Pages/login/state/login_bloc.dart';

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
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
        builder: (BuildContext context, LoginState state) {
      return Container(
          constraints: BoxConstraints(minHeight: 56),
          width: LoginPageConstants.maxWidth,
          padding: LoginPageConstants.verticalPadding,
          child: TextField(
            controller: this._passwordController,
            obscureText: !state.showPassword,
            onChanged: (_) {
              context.read<LoginBloc>().add(PasswordFieldChangedEvent(
                  password: this._passwordController.text));
            },
            decoration: InputDecoration(
                errorMaxLines: 2,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                prefixIcon: Icon(Icons.lock_rounded),
                suffixIcon: IconButton(
                  icon: state.showPassword
                      ? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off),
                  onPressed: () {
                    context.read<LoginBloc>().add(ShowPasswordClickedEvent());
                  },
                ),
                labelText: 'Password',
                errorText:
                    state.showPasswordError ? state.passwordError : null),
          ));
    });
  }
}
