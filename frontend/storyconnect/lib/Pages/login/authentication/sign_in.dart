import 'package:firebase_auth/firebase_auth.dart';

///
/// Attempts to complete the task of signing a user into the project
///
Future<void> signIn(String email, String password) async {
  try {
    final UserCredential credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  } on FirebaseAuthException catch (firebase_exception) {
    String exception_code = firebase_exception.code;

    //handle user or password exceptions
    if (exception_code == 'user-not-found') {
    } else if (exception_code == 'wrong-password') {}
  } on Exception catch (exception) {
    //something else went wrong
    print(exception.toString());
  } finally {}
}

///
/// Attempt to complete the task of creating a new user account
///
Future<void> signUp(String email, String password) async {
  try {
    final UserCredential credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  } on FirebaseAuthException catch (firebase_exception) {
    String exception_code = firebase_exception.code;

    //handle sign up exceptions
    if (exception_code == 'weak-password') {
    } else if (exception_code == 'email-already-in-use') {}
  } on Exception catch (exception) {}
}
