import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/login/components/layout_constants.dart';
import 'package:storyconnect/Pages/login/state/login_bloc.dart';

class EmailField extends StatefulWidget {
  const EmailField();

  @override
  _emailState createState() => _emailState();
}

class _emailState extends State<EmailField> {
  final TextEditingController _emailController = TextEditingController();

  _emailState();

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
            controller: this._emailController,
            obscureText: false,
            onChanged: (_) {
              context.read<LoginBloc>().add(
                  EmailFieldChangedEvent(email: this._emailController.text));
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                prefixIcon: Icon(Icons.email_rounded),
                labelText: 'Email',
                errorText: state.showEmailError ? state.emailError : null),
          ));
    });
  }
}
