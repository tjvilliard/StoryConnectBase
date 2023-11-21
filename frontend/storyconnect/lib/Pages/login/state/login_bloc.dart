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
    _repo = repo;

    on<EmailFieldChangedEvent>((event, emit) => _emailFieldChanged(event, emit));
    on<PasswordFieldChangedEvent>((event, emit) => _passwordFieldChanged(event, emit));
    on<ShowPasswordClickedEvent>((event, emit) => _showPasswordClicked(event, emit));
    on<LoginButtonPushedEvent>((event, emit) => _loginButtonPushed(event, emit));
    on<StayLoggedInCheckedEvent>((event, emit) => _stayLoggedInChecked(event, emit));
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
    bool emailValid = state.email.isNotEmpty;
    bool passwordValid = state.password.isNotEmpty;

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
      String? message = await _repo.signIn(state.email, state.password);

      if (message == FirebaseRepository.SUCCESS) {
        emit(state.copyWith(success: true));
        return;
      } else if (message!.toLowerCase().contains("email")) {
        emit(state.copyWith(
          emailError: message,
          showEmailError: true,
        ));
      } else {
        // password error.
      }

      return;
    }
  }

  _stayLoggedInChecked(StayLoggedInCheckedEvent event, LoginEmitter emit) {
    emit(state.copyWith(
      staySignedIn: !state.staySignedIn,
    ));
  }
}
