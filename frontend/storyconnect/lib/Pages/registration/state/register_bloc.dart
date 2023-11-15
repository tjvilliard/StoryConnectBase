import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Repositories/firebase_repository.dart';

part 'register_events.dart';
part 'register_state.dart';
part 'register_bloc.freezed.dart';

typedef RegistrationEmitter = Emitter<RegistrationState>;

///
class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  late final FirebaseRepository _repo;

  /// Maps Events to Event Handlers.
  RegistrationBloc(FirebaseRepository repo)
      : super(RegistrationState.initial()) {
    this._repo = repo;
    on<EmailFieldChangedEvent>(
      (event, emit) => this._emailFieldChanged(event, emit),
    );
    on<DisplayNameChangedEvent>(
        (event, emit) => this._displayNameFieldChanged(event, emit));
    on<PasswordFieldChangedEvent>(
        (event, emit) => this._passwordFieldChanged(event, emit));
    on<PasswordConfirmFieldChangedEvent>(
        (event, emit) => this._passwordConfirmFieldChanged(event, emit));
    on<ShowPasswordClickedEvent>(
        (event, emit) => this._showPasswordClicked(event, emit));
    on<ShowPasswordConfirmClickedEvent>(
        (event, emit) => this._showPasswordConfirmClicked(event, emit));
    on<RegisterButtonPushedEvent>(
        (event, emit) => this._registerButtonPushed(event, emit));
  }

  /// Event handler for an EmailFieldChangedEvent, alters the state of the email text field.
  void _emailFieldChanged(
      EmailFieldChangedEvent event, RegistrationEmitter emit) {
    emit(state.copyWith(
      email: event.email,
      emailError: "",
      showEmailError: false,
    ));
  }

  /// Event Handler for a DisplayNameFieldChangedEvent, alters the state of the displayname text field.
  void _displayNameFieldChanged(
      DisplayNameChangedEvent event, RegistrationEmitter emit) {
    emit(state.copyWith(
      displayName: event.displayName,
      displayNameError: "",
      showDisplayNameError: false,
    ));
  }

  /// Event handler for a PasswordFieldChangedEvent, alters the state of the password text field.
  void _passwordFieldChanged(
      PasswordFieldChangedEvent event, RegistrationEmitter emit) {
    emit(state.copyWith(
      password: event.password,
      passwordError: "",
      showPasswordError: false,
    ));
  }

  /// Event handler for a PasswordConfirmFieldChangedEvent, alters the state of the password confirmation field.
  void _passwordConfirmFieldChanged(
      PasswordConfirmFieldChangedEvent event, RegistrationEmitter emit) {
    emit(state.copyWith(
      confirmPassword: event.confirmPassword,
      confirmPasswordError: "",
      showConfirmPasswordError: false,
    ));
  }

  ///
  void _showPasswordClicked(
      ShowPasswordClickedEvent event, RegistrationEmitter emit) {
    emit(state.copyWith(showPassword: !state.showPassword));
  }

  ///
  void _showPasswordConfirmClicked(
      ShowPasswordConfirmClickedEvent event, RegistrationEmitter emit) {
    emit(state.copyWith(showConfirmPassword: !state.showConfirmPassword));
  }

  ///
  void _registerButtonPushed(
      RegisterButtonPushedEvent event, RegistrationEmitter emit) async {
    bool emailValid = this.validateEmail(emit);

    bool displayNameValid = false;

    bool passwordsValid = this.validatePassword(emit);

    if (emailValid & displayNameValid & passwordsValid) {
      String response = await this
          ._repo
          .register(state.email, state.displayName, state.password);

      if (response == FirebaseRepository.SUCCESS) {
        emit(state.copyWith(success: true));
        return;
      } else {
        if (response.toLowerCase().contains("account") ||
            response.toLowerCase().contains("email")) {
          emit(state.copyWith(
            emailError: response,
            showEmailError: true,
          ));
        } else {
          emit(state.copyWith(
            passwordError: response,
            showPasswordError: true,
          ));
        }
      }
    } else {
      return;
    }
  }

  /// Validates the email field.
  bool validateEmail(RegistrationEmitter emit) {
    if (this.state.email.isEmpty) {
      emit(state.copyWith(
        emailError: "Email field cannot be empty.",
        showEmailError: true,
      ));
      return false;
    } else {
      return true;
    }
  }

  bool validateDisplayName(RegistrationEmitter emit) {
    return false;
  }

  /// Validates the password fields.
  bool validatePassword(RegistrationEmitter emit) {
    if (this.state.password.isEmpty || this.state.confirmPassword.isEmpty) {
      if (this.state.password.isEmpty) {
        emit(state.copyWith(
          passwordError: "Password field cannot be empty.",
          showPasswordError: true,
        ));
      }

      if (this.state.confirmPassword.isEmpty) {
        emit(state.copyWith(
          confirmPasswordError: "Confirmation field cannot be empty.",
          showConfirmPasswordError: true,
        ));
      }

      return false;
    }

    if (this.state.password != this.state.confirmPassword) {
      emit(state.copyWith(
        passwordError: "Password must be equal to confirmation password.",
        confirmPasswordError:
            "Confirmation password must be equal to password.",
        showPasswordError: true,
        showConfirmPasswordError: true,
      ));
      return false;
    }

    int length = this.state.password.length;
    if (length > 16 || length < 8) {
      emit(state.copyWith(
        passwordError:
            "Password must be between 8 and 16 characters in length.",
        showPasswordError: true,
      ));
    }

    // Special Characters list.
    const List<String> specialChars = <String>[
      '!',
      '@',
      '#',
      '\$',
      '%',
      '^',
      '&',
      '*',
      '(',
      ')',
    ];

    const List<String> digits = <String>[
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
    ];

    if (!specialChars.any((char) => this.state.password.contains(char)) &&
        !digits.any((digit) => this.state.password.contains(digit))) {
      emit(state.copyWith(
        passwordError:
            "Password must contain at least one of the digits 0 - 9 and " +
                "at least one of the following special characters: !, @, #, \$, %, ^, &, *, (, ).",
        showPasswordError: true,
      ));

      return false;
    } else if (!digits.any((digit) => this.state.password.contains(digit))) {
      emit(state.copyWith(
        passwordError:
            "Password must contain at least one of the digits 0 - 9.",
        showPasswordError: true,
      ));
      return false;
    } else if (!specialChars
        .any((char) => this.state.password.contains(char))) {
      emit(state.copyWith(
        passwordError:
            "Password must contain at least one of the following special characters: !, @, #, \$, %, ^, &, *, (, ).",
        showPasswordError: true,
      ));
      return false;
    }

    return true;
  }
}
