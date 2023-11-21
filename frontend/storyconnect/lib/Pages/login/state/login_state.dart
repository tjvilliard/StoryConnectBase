part of 'login_bloc.dart';

/// Records the state of our login view.
@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    required String email,
    required String emailError,
    required bool showEmailError,
    required String password,
    required String passwordError,
    required bool showPassword,
    required bool showPasswordError,
    required bool staySignedIn,
    required bool success,
  }) = _LoginState;
  const LoginState._();

  factory LoginState.initial() {
    return LoginState(
      email: "",
      emailError: "",
      showEmailError: false,
      password: "",
      passwordError: "",
      showPasswordError: false,
      showPassword: false,
      staySignedIn: false,
      success: false,
    );
  }
}
