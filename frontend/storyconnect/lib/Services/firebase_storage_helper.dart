import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadImageDirectlyToFirebase(Uint8List imageBytes) async {
  FirebaseStorage storage = FirebaseStorage.instance;

  // handle auth here
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception("User is not logged in.");
  }

  final relativeUrl = "images/${user.uid}/${DateTime.now().toIso8601String()}.png";

  Reference ref = storage.ref().child(relativeUrl);
  // upload the file as public
  UploadTask uploadTask = ref.putData(imageBytes);
  await uploadTask;

  return relativeUrl;
}
