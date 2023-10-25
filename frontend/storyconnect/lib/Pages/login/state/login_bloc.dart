import 'dart:ffi';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Repositories/firebase_repository.dart';

part 'login_events.dart';
part 'login_state.dart';
part 'login_bloc.freezed.dart';

typedef LoginEmitter = Emitter<LoginState>;

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  late final FirebaseRepository _repo;

  LoginBloc(FirebaseRepository repo) : super(LoginState.initial()) {
    this._repo = repo;

    on<EmailFieldChangedEvent>((event, emit) => emailFieldChanged(event, emit));
  }

  emailFieldChanged(EmailFieldChangedEvent event, LoginEmitter emit) {}

  passwordFieldChanged(PasswordFieldChangedEvent event, LoginEmitter emit) {}

  String _passwordVerify(String password) {
    if (password.isEmpty) {
      return "Password must not be empty";
    }

    int passwordLength = password.length;
    if (passwordLength < 8 || passwordLength > 16) {
      return "Password must be between 8 and 16 characters long";
    }

    List<String> special = ['!', '@', '#', '\$', '%', '^', '&', '*'];

    if (!special.any((character) => password.contains(character))) {
      return "Password must contain one of the following characters: " +
          "!, @, #, \$, %, ^, &, *";
    }

    return "";
  }

  loginButtonPushed(LoginButtonPushedEvent event, LoginEmitter emit) {}

  stayLoggedInChecked(StayLoggedInCheckedEvent event, LoginEmitter emit) {}

  accountCreationButtonPushed(
      AccountCreationButtonPushedEvent event, LoginEmitter emit) {}

  forgotPasswordButtonPushed(
      ForgotPasswordButtonPushedEvent event, LoginEmitter emit) {}
}
