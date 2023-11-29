import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyconnect/Pages/login/components/layout_constants.dart';
import 'package:storyconnect/Pages/login/state/login_bloc.dart';

class StaySignedInBox extends StatelessWidget {
  const StaySignedInBox({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (BuildContext context, LoginState state) {
        return Container(
            width: LoginPageConstants.maxWidth,
            padding: LoginPageConstants.verticalPadding,
            child: Row(children: [
              Checkbox.adaptive(
                  value: state.staySignedIn,
                  onChanged: (_) {
                    context.read<LoginBloc>().add(const StayLoggedInCheckedEvent());
                  }),
              const Text("Stay Signed In?"),
            ]));
      },
    );
  }
}
