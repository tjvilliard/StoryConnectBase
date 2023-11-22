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
    _firebaseRepo = firebaseRepo;
    _coreRepo = coreRepo;
    on<EmailFieldChangedEvent>(
      (event, emit) => _emailFieldChanged(event, emit),
    );
    on<DisplayNameChangedEvent>(
        (event, emit) => _displayNameFieldChanged(event, emit));
    on<PasswordFieldChangedEvent>(
        (event, emit) => _passwordFieldChanged(event, emit));
    on<PasswordConfirmFieldChangedEvent>(
        (event, emit) => _passwordConfirmFieldChanged(event, emit));
    on<ShowPasswordClickedEvent>(
        (event, emit) => _showPasswordClicked(event, emit));
    on<ShowPasswordConfirmClickedEvent>(
        (event, emit) => _showPasswordConfirmClicked(event, emit));
    on<RegisterButtonPushedEvent>(
        (event, emit) => _registerButtonPushed(event, emit));
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
    bool emailValid = await validateEmail(emit);

    bool displayNameValid = await validateDisplayName(emit);

    bool passwordsValid = validatePassword(emit);

    if (emailValid & displayNameValid & passwordsValid) {
      //String response = await _repo

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
      // print("[DEBUG] Field failed validity check.");
      return;
    }
  }

  /// Checks the validity of the provided email field.
  Future<bool> validateEmail(RegistrationEmitter emit) async {
    if (state.email.isEmpty) {
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
    } else if (!await _firebaseRepo.validateEmail(state.email)) {
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
    if (state.displayName.isEmpty) {
      emit(state.copyWith(
        displayNameError: "Display Name field cannot be empty.",
        showDisplayNameError: true,
      ));
      return false;
    }

    if (await _coreRepo.verifyDisplayNameUniqueness(state.displayName)) {
      emit(state.copyWith(
        displayNameError: "Display Name is already in use.",
        showDisplayNameError: true,
      ));
      return false;
    }

    return true;
  }

  /// Validates the password fields.
  bool validatePassword(RegistrationEmitter emit) {
    if (state.password.isEmpty || state.confirmPassword.isEmpty) {
      if (state.password.isEmpty) {
        emit(state.copyWith(
          passwordError: "Password field cannot be empty.",
          showPasswordError: true,
        ));
      }

      if (state.confirmPassword.isEmpty) {
        emit(state.copyWith(
          confirmPasswordError: "Confirmation field cannot be empty.",
          showConfirmPasswordError: true,
        ));
      }

      return false;
    }

    if (state.password != state.confirmPassword) {
      emit(state.copyWith(
        passwordError: "Password must be equal to confirmation password.",
        confirmPasswordError:
            "Confirmation password must be equal to password.",
        showPasswordError: true,
        showConfirmPasswordError: true,
      ));
      return false;
    }

    int length = state.password.length;
    int confirmLength = state.confirmPassword.length;
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
        specialChars.any((char) => state.password.contains(char));
    bool passwordHasDigit =
        digits.any((digit) => state.password.contains(digit));
    bool confirmPasswordHasChar =
        specialChars.any((char) => state.confirmPassword.contains(char));
    bool confirmPasswordHasDigit =
        digits.any((digit) => state.confirmPassword.contains(digit));

    if (!passwordHasLength ||
        !confirmPasswordHasLength ||
        !passwordHasChar ||
        !passwordHasDigit ||
        !confirmPasswordHasChar ||
        !confirmPasswordHasDigit) {
      String passwordError = "";
      String confirmPasswordError = "";

      // Password Error messages.
      if (!passwordHasLength) {
        passwordError +=
            "Password must be between 8 and 16 characters in length.";
      }
      if (!passwordHasChar) {
        passwordError +=
            "Password must contain one of the following special characters: . ";
      }
      if (!passwordHasDigit) {
        passwordError += "Password must contain at least one digit 0 - 9. ";
      }
      if (!confirmPasswordHasLength) {
        confirmPasswordError +=
            "Password must be between 8 and 16 characters in length.";
      }
      if (!confirmPasswordHasChar) {
        confirmPasswordError +=
            "Password must contain one of the following special characters: . ";
      }
      if (!confirmPasswordHasDigit) {
        confirmPasswordError +=
            "Password must contain at least one digit 0 - 9. ";
      }

      // If our error message isn't empty, emit it.
      if (passwordError.isNotEmpty) {
        emit(state.copyWith(
          passwordError: passwordError,
          showPasswordError: true,
        ));
      }

      return false;
    } else if (!digits.any((digit) => state.password.contains(digit))) {
      emit(state.copyWith(
        passwordError:
            "Password must contain at least one of the digits 0 - 9.",
        showPasswordError: true,
      ));
      return false;
    } else {
      return true;
    }
  }
}
