// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/resources/providers/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utilities.dart';

class AddPostScreen extends ConsumerStatefulWidget {
  const AddPostScreen({super.key});

  @override
  ConsumerState<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends ConsumerState<AddPostScreen> {
  Uint8List? _file;
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  void postImage(String uid, String username, String image) async {
    String desc = _descriptionController.text;
    setState(() {
      _isLoading = true;
    });
    try {
      if (desc.isEmpty ||
          desc.trim().isEmpty ||
          image.isEmpty ||
          _file == null) {
        showSnackBar(
          context: context,
          content: 'Please enter all fields',
          bgColor: mobileSearchColor,
          textColor: primaryColor,
        );
      }
      String res = await FirestoreMethods().uploadPost(
        desc,
        _file!,
        uid,
        username,
        image,
      );
      if (res == 'Success') {
        showSnackBar(
          context: context,
          content: 'Posted!',
          bgColor: mobileSearchColor,
          textColor: primaryColor,
        );
      } else {
        showSnackBar(
          context: context,
          content: res,
          bgColor: mobileSearchColor,
          textColor: primaryColor,
        );
      }
      setState(() {
        _isLoading = false;
      });
      clearImage();
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  _selectImage(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text(
                'Take a photo',
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImageCamera(context);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text(
                'Choose from gallery',
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImageGallery(context);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text(
                'Cancel',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return _file == null
        ? Center(
            child: IconButton(
              onPressed: () => _selectImage(context),
              icon: const Icon(Icons.upload),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                ),
                onPressed: clearImage,
              ),
              title: const Text('Post to'),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () => postImage(
                    user!.uid,
                    user.username,
                    user.photoUrl,
                  ),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                _isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(
                        padding: EdgeInsets.only(top: 0),
                      ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        user!.photoUrl,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          hintText: 'Write a caption...',
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              ],
            ),
          );
  }
}
