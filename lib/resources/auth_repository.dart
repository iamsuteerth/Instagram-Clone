// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/utils/firebase_constants.dart';

class AuthRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference get users =>
      firestore.collection(FirebaseConstants.usersCollection);

  Future<UserModel> getUserDetails() async {
    User currentUser = auth.currentUser!;
    DocumentSnapshot snap = await users.doc(currentUser.uid).get();
    return UserModel.fromSnap(snap);
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty) {
        RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
        if (email.trim().isEmpty || !emailRegex.hasMatch(email)) {
          res = "Please enter a valid email address";
        }
        if (bio.length >= 150) {
          res = "Bio length exceeds 150 characters";
        }
        if (password.trim().isEmpty || password.trim().length < 8) {
          res = 'Password length must be > 8';
        }

        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String photoUrl = await StorageMethods()
            .uploadImagetoStorage('profilePics', file, false);

        UserModel user = UserModel(
          email: email,
          uid: userCredential.user!.uid,
          photoUrl: photoUrl,
          username: username,
          bio: bio,
          followers: [],
          following: [],
        );

        await users.doc(userCredential.user!.uid).set(user.toMap());
        res = 'Success';
      } else {
        res = "Please enter all the fields";
      }
      return res;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> singInUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
        if (email.trim().isEmpty || !emailRegex.hasMatch(email)) {
          res = "Please enter a valid email address";
        } else {
          await auth.signInWithEmailAndPassword(
              email: email, password: password);
          res = 'Success';
        }
      } else {
        res = "Please enter all the fields";
      }
      return res;
    } on FirebaseAuthException catch (_) {
      return 'Invalid Credentials';
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
