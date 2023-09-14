import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:storyconnect/Pages/login/view.dart';
import 'package:storyconnect/Services/Authentication/authentication_service.dart';

///
/// Wrapper class that handles authentication checking for a page.
///
class AuthenticationWrapper extends StatelessWidget {
  late final Widget _child;
  late final Stream<User?> _authState;
  late final AuthenticationService _authService = AuthenticationService();
  final bool _require;

  /// Get the authenticaton state
  Stream<User?> get state {
    return this._authState;
  }

  AuthenticationWrapper(Widget child, this._require) {
    this._child = child;
    this._authState = this._authService.authStateChanges;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: this._authState,
        builder: (context, snapshot) {
          if (this._require) {
            if (snapshot.hasData) {
              return this._child;
            } else {
              return LoginPage();
            }
          } else {
            return this._child;
          }
        });
  }
}
