// ignore_for_file: constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

enum FirebaseCodeDescriptors {
  SUCCESS(
    code: "Success",
    message: "Success",
  ),
  InvalidEmail(
    code: "invalid-email",
    message: "Email format is invalid.",
  ),
  EmailAlreadyInUse(
    code: "email-already-in-use",
    message: "Email is Already in Use",
  ),
  UserDisabled(
    code: "",
    message: "",
  ),
  UserNotFound(
    code: "user-not-found",
    message: "User Does Not Exist",
  ),
  WrongPassword(
    code: "wrong-password",
    message: "The Password is Incorrect",
  ),
  UnmappedError(
    code: "",
    message: "Other Unmapped Error",
  );

  const FirebaseCodeDescriptors({required this.message, required this.code});
  final String message;
  final String code;
}

/// Singleton Class encapsulating firebase functions.
class FirebaseRepository {
  late final FirebaseAuth _firebaseAuth;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  static const String SUCCESS = "Success";

  static final FirebaseRepository _instance = FirebaseRepository._internal();

  FirebaseRepository._internal() {
    _firebaseAuth = FirebaseAuth.instance;
  }

  factory FirebaseRepository() {
    return FirebaseRepository._instance;
  }

  /// Verifies the uniqueness of an email address.
  Future<bool> validateEmail(String email) async {
    final List<String> methods =
        await _firebaseAuth.fetchSignInMethodsForEmail(email);

    return methods.isEmpty;
  }

  ///
  Future<String> register(
      String email, String displayName, String password) async {
    try {
      UserCredential credential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        credential.user?.updateDisplayName(displayName);
      }

      return FirebaseRepository.SUCCESS;
    } on FirebaseAuthException catch (firebaseError) {
      if (kDebugMode) {
        print(firebaseError.code);
      }

      if (firebaseError.code == FirebaseCodeDescriptors.UserNotFound.code) {
        return FirebaseCodeDescriptors.UserNotFound.message;
      } else if (firebaseError.code ==
          FirebaseCodeDescriptors.InvalidEmail.code) {
        return FirebaseCodeDescriptors.InvalidEmail.message;
      } else if (firebaseError.code ==
          FirebaseCodeDescriptors.WrongPassword.code) {
        return FirebaseCodeDescriptors.WrongPassword.message;
      } else if (firebaseError.code ==
          FirebaseCodeDescriptors.EmailAlreadyInUse.code) {
        return FirebaseCodeDescriptors.EmailAlreadyInUse.message;
      } else {
        return FirebaseCodeDescriptors.UnmappedError.message;
      }
    }
  }

  ///
  Future<String?> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return FirebaseRepository.SUCCESS;
    } on FirebaseAuthException catch (firebaseError) {
      if (firebaseError.code == 'user-not-found') {
        return FirebaseCodeDescriptors.UserNotFound.message;
      } else if (firebaseError.code == 'wrong-password') {
        return FirebaseCodeDescriptors.WrongPassword.message;
      } else if (firebaseError.code == "email-already-in-use") {
        return FirebaseCodeDescriptors.EmailAlreadyInUse.message;
      } else {
        return FirebaseCodeDescriptors.UnmappedError.message;
      }
    }
  }

  ///
  Future<void> updateDisplayName(String displayName) async {
    try {
      User? user = _firebaseAuth.currentUser;

      await user?.updateDisplayName(displayName);
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
