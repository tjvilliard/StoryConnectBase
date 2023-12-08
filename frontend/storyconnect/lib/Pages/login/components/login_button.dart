import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/login/components/layout_constants.dart';
import 'package:storyconnect/Pages/login/state/login_bloc.dart';
import 'package:storyconnect/Services/url_service.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) => {
        if (state.success) {Beamer.of(context).beamToNamed(PageUrls.writerHome)}
      },
      builder: (context, state) {
        return Container(
            width: LoginPageConstants.maxWidth,
            constraints: const BoxConstraints(minHeight: 56),
            padding: LoginPageConstants.verticalPadding,
            child: OutlinedButton(
              style: ButtonStyle(
                  textStyle: const MaterialStatePropertyAll(
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)))),
              onPressed: () {
                context.read<LoginBloc>().add(const LoginButtonPushedEvent());
              },
              child: const Text("Sign In"),
            ));
      },
    );
  }
}
