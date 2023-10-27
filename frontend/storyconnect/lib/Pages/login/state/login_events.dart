part of 'login_bloc.dart';

/// Encapuslating type for all login events.
abstract class LoginEvent {
  const LoginEvent();
}

/// Action for when user changes contents of email field.
class EmailFieldChangedEvent extends LoginEvent {
  final String email;
  const EmailFieldChangedEvent({required this.email});
}

/// Action for when user changes contents of password field.
class PasswordFieldChangedEvent extends LoginEvent {
  final String password;
  const PasswordFieldChangedEvent({required this.password});
}

class ShowPasswordClickedEvent extends LoginEvent {
  const ShowPasswordClickedEvent();
}

/// Action for when the user presses the login button.
class LoginButtonPushedEvent extends LoginEvent {
  const LoginButtonPushedEvent();
}

/// Action for when the user presses the stay logged in button.
class StayLoggedInCheckedEvent extends LoginEvent {
  const StayLoggedInCheckedEvent();
}

/// Action for when the user presses the account creation button.
class AccountCreationButtonPushedEvent extends LoginEvent {
  const AccountCreationButtonPushedEvent();
}

/// Action for when the user presses the forgot password button.
class ForgotPasswordButtonPushedEvent extends LoginEvent {
  const ForgotPasswordButtonPushedEvent();
}
