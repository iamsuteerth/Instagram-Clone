// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/resources/providers/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utilities.dart';
import 'package:instagram_clone/utils/widgets/comment_card.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String postId;
  static const String routeName = 'comments-screen';
  const CommentsScreen({
    super.key,
    required this.postId,
  });

  @override
  ConsumerState<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final TextEditingController textEditingController = TextEditingController();

  void postComment(String uid, String name, String profilePic) async {
    try {
      String res = await FirestoreMethods().postComment(
        name: name,
        postId: widget.postId,
        profilePic: profilePic,
        text: textEditingController.text,
        uid: uid,
      );

      if (res != 'success') {
        if (context.mounted) {
          showSnackBar(
            context: context,
            content: res,
            bgColor: mobileSearchColor,
            textColor: primaryColor,
          );
        }
      }
      setState(() {
        textEditingController.text = "";
      });
    } catch (err) {
      showSnackBar(context: context, content: err.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Comments'),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .collection('comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return CommentCard(
                  snap: snapshot.data!.docs[index],
                  postId: widget.postId,
                );
              },
            );
          }
          return const Center(child: Text('Some error ocurred'));
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user!.photoUrl),
                radius: 16,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                        hintText: 'Comment as ${user.username}'),
                  ),
                ),
              ),
              InkWell(
                onTap: () =>
                    postComment(user.uid, user.username, user.photoUrl),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: blueColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FireStoreMethods {}
