import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  static const String SUCCESS = "Success";

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => this._firebaseAuth.authStateChanges();

  Future<String?> signIn(String email, String password) async {
    try {
      UserCredential credential = await this
          ._firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      print(credential.credential!.accessToken);

      return SUCCESS;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> signUp(String email, String password) async {
    try {
      await this
          ._firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return SUCCESS;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> signInAnon() async {
    try {
      await this._firebaseAuth.signInAnonymously();

      return SUCCESS;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
