import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/login/state/login_bloc.dart';

class RecoveryLinkButton extends StatelessWidget {
  const RecoveryLinkButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
        builder: (BuildContext context, LoginState state) {
      return OutlinedButton(
          style: ButtonStyle(
              textStyle: const MaterialStatePropertyAll(
                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)))),
          onPressed: () {},
          child: const Text("Forgot Password?"));
    });
  }
}
