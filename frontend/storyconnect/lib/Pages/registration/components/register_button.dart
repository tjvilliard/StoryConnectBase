import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/login/components/layout_constants.dart';
import 'package:storyconnect/Pages/registration/state/register_bloc.dart';
import 'package:storyconnect/Services/url_service.dart';

class RegistrationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegistrationBloc, RegistrationState>(
      listener: (context, state) => {
        if (state.success) {Beamer.of(context).beamToNamed(PageUrls.writerHome)}
      },
      builder: (context, state) {
        return Container(
            width: LoginPageConstants.maxWidth,
            padding: LoginPageConstants.verticalPadding,
            child: OutlinedButton(
              style: ButtonStyle(
                  textStyle: MaterialStatePropertyAll(
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)))),
              onPressed: () {
                context
                    .read<RegistrationBloc>()
                    .add(RegisterButtonPushedEvent());
              },
              child: Text("Register"),
            ));
      },
    );
  }
}