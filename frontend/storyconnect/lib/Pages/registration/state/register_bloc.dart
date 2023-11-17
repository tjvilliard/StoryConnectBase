import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyconnect/Repositories/core_repository.dart';
import 'package:storyconnect/Repositories/firebase_repository.dart';

part 'register_events.dart';
part 'register_state.dart';
part 'register_bloc.freezed.dart';

typedef RegistrationEmitter = Emitter<RegistrationState>;

///
class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  late final FirebaseRepository _firebaseRepo;
  late final CoreRepository _coreRepo;

  /// Maps Events to Event Handlers.
  RegistrationBloc(FirebaseRepository firebaseRepo, CoreRepository coreRepo)
      : super(RegistrationState.initial()) {
    this._firebaseRepo = firebaseRepo;
    this._coreRepo = coreRepo;
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
    bool emailValid = await this.validateEmail(emit);

    bool displayNameValid = await this.validateDisplayName(emit);

    bool passwordsValid = this.validatePassword(emit);

    print(
        "[DEBUG]: Email: ${emailValid}, Display Name: ${displayNameValid}, Password: ${passwordsValid}");

    if (emailValid & displayNameValid & passwordsValid) {
      print("[DEBUG] Fields passed validity check.");

      /*
      String response = await this
          ._firebaseRepo
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
      */
    } else {
      print("[DEBUG] Field failed validity check.");
      return;
    }
  }

  /// Checks the validity of the provided email field.
  Future<bool> validateEmail(RegistrationEmitter emit) async {
    if (this.state.email.isEmpty) {
      emit(state.copyWith(
        emailError: "Email field cannot be empty.",
        showEmailError: true,
      ));
      return false;
    } else if (!RegExp(
            r"^[a-zA-Z0-9.!#$%&'+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)$")
        .hasMatch(state.email)) {
      emit(state.copyWith(
        emailError: "Email format is invalid.",
        showEmailError: true,
      ));
      return false;
    } else if (!await this._firebaseRepo.validateEmail(state.email)) {
      emit(state.copyWith(
        emailError: "Email is already in use.",
        showEmailError: true,
      ));
      return false;
    } else {
      return true;
    }
  }

  /// Checks the validity of the provided display name.
  Future<bool> validateDisplayName(RegistrationEmitter emit) async {
    if (this.state.displayName.isEmpty) {
      emit(this.state.copyWith(
            displayNameError: "Display Name field cannot be empty.",
            showDisplayNameError: true,
          ));
      return false;
    }

    if (await this
        ._coreRepo
        .verifyDisplayNameUniqueness(this.state.displayName)) {
      emit(this.state.copyWith(
            displayNameError: "Display Name is already in use.",
            showDisplayNameError: true,
          ));
      return false;
    }

    return true;
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
    int confirmLength = this.state.confirmPassword.length;
    bool passwordHasLength = length >= 8 && length <= 16;
    bool confirmPasswordHasLength = confirmLength >= 8 && confirmLength <= 16;

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
    ];
    bool passwordHasChar =
        specialChars.any((char) => this.state.password.contains(char));
    bool passwordHasDigit =
        digits.any((digit) => this.state.password.contains(digit));
    bool confirmPasswordHasChar =
        specialChars.any((char) => this.state.confirmPassword.contains(char));
    bool confirmPasswordHasDigit =
        digits.any((digit) => this.state.confirmPassword.contains(digit));

    if (!passwordHasLength ||
        !confirmPasswordHasLength ||
        !passwordHasChar ||
        !passwordHasDigit ||
        !confirmPasswordHasChar ||
        !confirmPasswordHasDigit) {
      String passwordError = "";
      String confirmPasswordError = "";

      // Password Error messages.
      if (!passwordHasLength)
        passwordError +=
            "Password must be between 8 and 16 characters in length.";
      if (!passwordHasChar)
        passwordError +=
            "Password must contain one of the following special characters: . ";
      if (!passwordHasDigit)
        passwordError += "Password must contain at least one digit 0 - 9. ";
      if (!confirmPasswordHasLength)
        confirmPasswordError +=
            "Password must be between 8 and 16 characters in length.";
      if (!confirmPasswordHasChar)
        confirmPasswordError +=
            "Password must contain one of the following special characters: . ";
      if (!confirmPasswordHasDigit)
        confirmPasswordError +=
            "Password must contain at least one digit 0 - 9. ";

      // If our error message isn't empty, emit it.
      if (!passwordError.isEmpty) {
        emit(state.copyWith(
          passwordError: passwordError,
          showPasswordError: true,
        ));
      }

      if (!confirmPasswordError.isEmpty) {
        emit(state.copyWith(
          confirmPasswordError: confirmPasswordError,
          showConfirmPasswordError: true,
        ));
      }

      return false;
    } else {
      return true;
    }
  }
}
