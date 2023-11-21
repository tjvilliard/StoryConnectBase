import 'package:firebase_auth/firebase_auth.dart';

class SignOutService {
  // Firebase Authentication State Singleton
  late final FirebaseAuth _firebaseAuth;

  // The static single instance of the class
  static final SignOutService _instance = SignOutService._internal();

  // Success return message.
  final String success = "Success";

  /// Gets the Sign-Out-Service Singleton
  factory SignOutService() {
    return _instance;
  }

  /// Creates the single instance of the Sign-Out-Service
  SignOutService._internal() {
    _firebaseAuth = FirebaseAuth.instance;
  }

  /// Sign Out of the app
  /// Returns an exception message or a success message.
  Future<String?> signOut() async {
    try {
      await this._firebaseAuth.signOut();
      return success;
    } on FirebaseAuthException catch (error) {
      return error.code;
    }
  }
}
