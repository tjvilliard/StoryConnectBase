part of 'login_bloc.dart';

/// Encapuslating type for all login events.
abstract class LoginEvent {
  const LoginEvent();
}

class EmailFieldChangedEvent extends LoginEvent {
  const EmailFieldChangedEvent();
}

///
class PasswordFieldChangedEvent extends LoginEvent {
  const PasswordFieldChangedEvent();
}

/// Action for when the user presses the login button.
class LoginButtonPushedEvent extends LoginEvent {
  const LoginButtonPushedEvent();
}

class StayLoggedInCheckedEvent extends LoginEvent {
  const StayLoggedInCheckedEvent();
}

class AccountCreationButtonPushedEvent extends LoginEvent {
  const AccountCreationButtonPushedEvent();
}

class ForgotPasswordButtonPushedEvent extends LoginEvent {
  const ForgotPasswordButtonPushedEvent();
}
