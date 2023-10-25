import 'package:firebase_auth/firebase_auth.dart';

/// Singleton Class encapsulating firebase functions.
class FirebaseRepository {
  late final FirebaseAuth _firebaseAuth;

  Stream<User?> get authStateChanges => this._firebaseAuth.authStateChanges();

  static const String _SUCCESS = "Success";

  static final FirebaseRepository _instance = FirebaseRepository._internal();

  FirebaseRepository._internal() {
    this._firebaseAuth = FirebaseAuth.instance;
  }

  factory FirebaseRepository() {
    return FirebaseRepository._instance;
  }

  Future<String?> signIn(String email, String password) async {
    try {
      await this
          ._firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      return FirebaseRepository._SUCCESS;
    } on FirebaseAuthException catch (firebaseError) {
      return firebaseError.message;
    }
  }
}
