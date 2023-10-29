import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/features/providers/firebase_providers.dart';

final firebaseStorageProvider = Provider(
  (ref) => StorageMethods(
    storage: ref.read(storageProvider),
    auth: ref.read(authProvider),
  ),
);

class StorageMethods {
  final FirebaseStorage storage;
  final FirebaseAuth auth;
  StorageMethods({
    required this.storage,
    required this.auth,
  });

  Future<String> uploadImagetoStorage(
      childName, Uint8List file, bool isPost) async {
    Reference reference =
        storage.ref().child(childName).child(auth.currentUser!.uid);
    UploadTask uploadTask = reference.putData(file);
    TaskSnapshot snap = await uploadTask;
    String downloadURL = await snap.ref.getDownloadURL();
    return downloadURL;
  }
}
