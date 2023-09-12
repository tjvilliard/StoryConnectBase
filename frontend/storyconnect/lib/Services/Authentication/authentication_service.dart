import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

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

      String idToken = await credential.user!.getIdToken(true) as String;

      String uid = this._firebaseAuth.currentUser!.uid;

      print(idToken.toString());

      http.put(Uri.parse("http://storyconnect.app/api/users/" + uid + "/"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Token " + idToken
          });

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
