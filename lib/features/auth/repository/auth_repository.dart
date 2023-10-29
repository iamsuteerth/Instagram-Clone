// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/features/providers/firebase_providers.dart';
import 'package:instagram_clone/features/storage_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/firebase_constants.dart';
import 'package:instagram_clone/utils/utilities.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    storageMethods: ref.read(firebaseStorageProvider),
  ),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final StorageMethods storageMethods;

  AuthRepository({
    required this.auth,
    required this.firestore,
    required this.storageMethods,
  });

  CollectionReference get users =>
      firestore.collection(FirebaseConstants.usersCollection);

  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Success!";
    bool error = false;
    try {
      RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
      if (email.trim().isEmpty || !emailRegex.hasMatch(email)) {
        res = "Please enter a valid email address";
        error = true;
      }
      if (bio.length >= 150) {
        res = "Bio length exceeds 150 characters";
        error = true;
      }
      if (password.trim().isEmpty || password.trim().length < 8) {
        res = 'Password length must be > 8';
        error = true;
      }
      if (error) {
        showSnackBar(
          context: context,
          content: res,
          bgColor: mobileSearchColor,
          textColor: primaryColor,
        );
        return;
      }

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String photoUrl =
          await storageMethods.uploadImagetoStorage('profilePics', file, false);

      await users.doc(userCredential.user!.uid).set(
        {
          'username': username,
          'uid': userCredential.user!.uid,
          'email': email,
          'bio': bio,
          'followers': [],
          'following': [],
          'photoURL': photoUrl,
        },
      );
      showSnackBar(
        context: context,
        content: res,
        bgColor: mobileSearchColor,
        textColor: primaryColor,
      );
    } catch (e) {
      showSnackBar(
        context: context,
        content: e.toString(),
        bgColor: mobileSearchColor,
        textColor: primaryColor,
      );
    }
  }
}
