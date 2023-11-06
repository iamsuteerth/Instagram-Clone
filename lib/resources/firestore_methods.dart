import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String desc,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = 'Some error ocurred';
    try {
      String photoUrl =
          await StorageMethods().uploadImagetoStorage('posts', file, true);
      final postId = const Uuid().v1();
      Post post = Post(
        description: desc,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
      );
      await _firestore.collection('posts').doc(postId).set(post.toMap());
      res = 'Success';
    } catch (e) {
      return e.toString();
    }
    return res;
  }
}
