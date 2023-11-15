part of 'register_bloc.dart';

/// Encapsulating Type for all login events.
abstract class RegistrationEvent {
  const RegistrationEvent();
}

/// Action for when user changes contents of email field.
class EmailFieldChangedEvent extends RegistrationEvent {
  final String email;
  const EmailFieldChangedEvent({required this.email});
}

class DisplayNameChangedEvent extends RegistrationEvent {
  final String displayName;
  const DisplayNameChangedEvent({required this.displayName});
}

/// Action for when user changes contents of password field.
class PasswordFieldChangedEvent extends RegistrationEvent {
  final String password;
  const PasswordFieldChangedEvent({required this.password});
}

/// Action for when user changes contents of password confirmation field.
class PasswordConfirmFieldChangedEvent extends RegistrationEvent {
  final String confirmPassword;
  const PasswordConfirmFieldChangedEvent({required this.confirmPassword});
}

/// Action for when user wants to see the contents of password field.
class ShowPasswordClickedEvent extends RegistrationEvent {}

/// Action for when user wants to see the contents of password confirmation field.
class ShowPasswordConfirmClickedEvent extends RegistrationEvent {}

/// Action for when user presses the registration button.
class RegisterButtonPushedEvent extends RegistrationEvent {}
