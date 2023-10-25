part of 'login_bloc.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    required String? email,
    required String? password,
    required bool showPassword,
    required bool staySignedIn,
  }) = _LoginState;
  const LoginState._();

  factory LoginState.initial() {
    return LoginState(
      email: "",
      password: "",
      showPassword: false,
      staySignedIn: false,
    );
  }
}
