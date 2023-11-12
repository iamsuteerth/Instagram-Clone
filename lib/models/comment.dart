import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String profilePic;
  final String uid;
  final String username;
  final List<String> likes;
  final String commentId;
  final DateTime datePublished;
  final String text;

  const Comment({
    required this.text,
    required this.uid,
    required this.username,
    required this.likes,
    required this.commentId,
    required this.datePublished,
    required this.profilePic,
  });

  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Comment(
        uid: snapshot["uid"],
        likes: snapshot["likes"],
        commentId: snapshot["commentId"],
        datePublished: snapshot["datePublished"],
        username: snapshot["username"],
        text: snapshot['text'],
        profilePic: snapshot['profilePic']);
  }

  Map<String, dynamic> toMap() => {
        "text": text,
        "uid": uid,
        "username": username,
        "likes": likes,
        "commentId": commentId,
        "datePublished": datePublished,
        'profilePic': profilePic,
      };
}
