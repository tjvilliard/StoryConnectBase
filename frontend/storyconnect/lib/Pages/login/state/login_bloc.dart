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

    on<EmailFieldChangedEvent>(
        (event, emit) => _emailFieldChanged(event, emit));
    on<PasswordFieldChangedEvent>(
        (event, emit) => _passwordFieldChanged(event, emit));
    on<ShowPasswordClickedEvent>(
        (event, emit) => _showPasswordClicked(event, emit));
    on<LoginButtonPushedEvent>(
        (event, emit) => _loginButtonPushed(event, emit));
    on<StayLoggedInCheckedEvent>(
        (event, emit) => _stayLoggedInChecked(event, emit));
  }

  _emailFieldChanged(EmailFieldChangedEvent event, LoginEmitter emit) {
    emit(state.copyWith(
      email: event.email,
      emailError: "",
      showEmailError: false,
    ));
  }

  _passwordFieldChanged(PasswordFieldChangedEvent event, LoginEmitter emit) {
    emit(state.copyWith(
      password: event.password,
      passwordError: "",
      showPasswordError: false,
    ));
  }

  _showPasswordClicked(ShowPasswordClickedEvent event, LoginEmitter emit) {
    emit(state.copyWith(
      showPassword: !state.showPassword,
    ));
  }

  _loginButtonPushed(LoginButtonPushedEvent event, LoginEmitter emit) async {
    bool emailValid = !state.email.isEmpty;
    bool passwordValid = !state.password.isEmpty;

    if (!emailValid) {
      emit(state.copyWith(
        emailError: "Email must not be empty!",
        showEmailError: true,
      ));
    }

    if (!passwordValid) {
      emit(state.copyWith(
        passwordError: "Password must not be empty!",
        showPasswordError: true,
      ));
    }

    if (!emailValid || !passwordValid) {
      return;
    } else {
      String? message = await this._repo.signIn(state.email, state.password);

      if (message!.toLowerCase().contains("email")) {
        emit(state.copyWith(
          emailError: message,
          showEmailError: true,
        ));
      }
      print(message);
      return;
    }
  }

  String _validatePassword(String password) {
    if (password.isEmpty) {
      return "Password must not be empty!";
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

  _stayLoggedInChecked(StayLoggedInCheckedEvent event, LoginEmitter emit) {
    emit(state.copyWith(
      staySignedIn: !state.staySignedIn,
    ));
  }
}
