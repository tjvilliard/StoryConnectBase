part of 'register_bloc.dart';

/// Records the state of our registration view.
@freezed
class RegistrationState with _$RegistrationState {
  const factory RegistrationState({
    required String email,
    required String emailError,
    required bool showEmailError,
    required String displayName,
    required String displayNameError,
    required bool showDisplayNameError,
    required String password,
    required String passwordError,
    required bool showPassword,
    required bool showPasswordError,
    required String confirmPassword,
    required String confirmPasswordError,
    required bool showConfirmPassword,
    required bool showConfirmPasswordError,
    required bool staySignedIn,
    required bool success,
  }) = _RegistrationState;
  const RegistrationState._();

  factory RegistrationState.initial() {
    return const RegistrationState(
      email: "",
      emailError: "",
      showEmailError: false,
      displayName: "",
      displayNameError: "",
      showDisplayNameError: false,
      password: "",
      passwordError: "",
      showPassword: false,
      showPasswordError: false,
      confirmPassword: "",
      confirmPasswordError: "",
      showConfirmPassword: false,
      showConfirmPasswordError: false,
      staySignedIn: false,
      success: false,
    );
  }
}
