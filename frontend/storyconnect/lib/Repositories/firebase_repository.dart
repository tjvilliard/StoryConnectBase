import 'package:firebase_auth/firebase_auth.dart';

enum FirebaseCodeDescriptors {
  SUCCESS(message: "Success"),
  EmailAlreadyInUse(message: "Email is Already in Use"),
  UserDisabled(message: ""),
  UserNotFound(message: "User Does Not Exist"),
  WrongPassword(message: "The Password is Incorrect"),
  UnmappedError(message: "Other Unmapped Error");

  const FirebaseCodeDescriptors({required this.message});
  final String message;
}

/// Singleton Class encapsulating firebase functions.
class FirebaseRepository {
  late final FirebaseAuth _firebaseAuth;

  Stream<User?> get authStateChanges => this._firebaseAuth.authStateChanges();

  User? get currentUser => this._firebaseAuth.currentUser;

  static const String SUCCESS = "Success";

  static final FirebaseRepository _instance = FirebaseRepository._internal();

  FirebaseRepository._internal() {
    this._firebaseAuth = FirebaseAuth.instance;
  }

  factory FirebaseRepository() {
    return FirebaseRepository._instance;
  }

  Future<String> register(String email, String password) async {
    try {
      await this._firebaseAuth.createUserWithEmailAndPassword(
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

  Future<String?> signIn(String email, String password) async {
    try {
      await this._firebaseAuth.signInWithEmailAndPassword(
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
}
