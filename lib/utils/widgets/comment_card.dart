import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/resources/providers/user_provider.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';

class CommentCard extends ConsumerStatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> snap;
  final String postId;
  const CommentCard({
    super.key,
    required this.snap,
    required this.postId,
  });

  @override
  ConsumerState<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends ConsumerState<CommentCard> {
  bool isLikeAnimating = false;
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 0),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  widget.snap['profilePic'],
                ),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: widget.snap['username'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '  ${widget.snap['text']}',
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          DateFormat.yMMMd().format(
                            widget.snap['datePublished'].toDate(),
                          ),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  left: 8,
                ),
                child: LikeAnimation(
                  isAnimating: widget.snap['likes'].contains(user!.uid),
                  smallLike: true,
                  onEnd: () {
                    setState(() {
                      isLikeAnimating = false;
                    });
                  },
                  child: IconButton(
                    onPressed: () async {
                      setState(() {
                        isLikeAnimating = true;
                      });
                      await FirestoreMethods().likeComment(
                        commentId: widget.snap['commentId'],
                        likes: widget.snap['likes'],
                        postId: widget.postId,
                        uid: user.uid,
                      );
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: widget.snap['likes'].contains(user.uid)
                          ? Colors.red
                          : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Spacer(),
              DefaultTextStyle(
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    '${widget.snap['likes'].length} likes',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
