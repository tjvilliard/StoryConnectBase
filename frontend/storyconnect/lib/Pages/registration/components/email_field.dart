import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:storyconnect/Pages/login/components/layout_constants.dart';
import 'package:storyconnect/Pages/registration/state/register_bloc.dart';

class EmailField extends StatefulWidget {
  const EmailField({super.key});

  @override
  EmailState createState() => EmailState();
}

class EmailState extends State<EmailField> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      builder: (context, state) {
        return Container(
          constraints: const BoxConstraints(minHeight: 56),
          width: LoginPageConstants.maxWidth,
          padding: LoginPageConstants.verticalPadding,
          child: TextField(
            controller: _emailController,
            obscureText: false,
            onChanged: (_) {
              context.read<RegistrationBloc>().add(EmailFieldChangedEvent(email: _emailController.text));
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                prefixIcon: const Icon(FontAwesomeIcons.envelope),
                labelText: 'Email',
                errorText: state.showEmailError ? state.emailError : null),
          ),
        );
      },
    );
  }
}
