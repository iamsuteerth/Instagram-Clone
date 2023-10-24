import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar(
    {required BuildContext context,
    required String content,
    Color? bgColor,
    Color? textColor}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        content,
        style: textColor != null
            ? TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              )
            : null,
      ),
      backgroundColor: bgColor ?? bgColor,
    ),
  );
}

pickImageGallery(BuildContext context) async {
  try {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );
    if (pickedImage != null) {
      return await pickedImage.readAsBytes();
    }
  } catch (e) {
    // ignore: use_build_context_synchronously
    showSnackBar(
      context: context,
      content: 'Something went wrong',
      bgColor: Colors.black38,
      textColor: Colors.white,
    );
  }
}
