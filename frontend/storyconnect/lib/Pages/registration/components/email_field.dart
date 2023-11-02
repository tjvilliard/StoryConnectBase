import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/login/components/layout_constants.dart';
import 'package:storyconnect/Pages/registration/state/register_bloc.dart';

class EmailField extends StatefulWidget {
  @override
  _emailState createState() => _emailState();
}

class _emailState extends State<EmailField> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    this._emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      builder: (context, state) {
        return Container(
          constraints: BoxConstraints(minHeight: 56),
          width: LoginPageConstants.maxWidth,
          padding: LoginPageConstants.verticalPadding,
          child: TextField(
            controller: this._emailController,
            obscureText: false,
            onChanged: (_) {
              context.read<RegistrationBloc>().add(
                  EmailFieldChangedEvent(email: this._emailController.text));
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                prefixIcon: Icon(Icons.email_rounded),
                labelText: 'Email',
                errorText: state.showEmailError ? state.emailError : null),
          ),
        );
      },
    );
  }
}
