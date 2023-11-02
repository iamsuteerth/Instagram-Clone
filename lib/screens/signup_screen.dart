import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/resources/auth_repository.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utilities.dart';
import 'package:instagram_clone/utils/widgets/text_field_input.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});
  static const String routeName = 'Sign-Up-Screen';
  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  Uint8List? image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    bioController.dispose();
    usernameController.dispose();
  }

  void pickImage() async {
    Uint8List im = await pickImageGallery(context);
    setState(() {
      image = im;
    });
  }

  void signUpUser(BuildContext context) async {
    if (image == null) {
      showSnackBar(
        context: context,
        content: 'Please select an image',
        bgColor: mobileSearchColor,
        textColor: primaryColor,
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });
    String res = await AuthRepository().signUpUser(
      email: emailController.text,
      password: passwordController.text,
      username: usernameController.text,
      bio: bioController.text,
      file: image!,
    );
    setState(() {
      _isLoading = false;
    });
    if (res == 'Success') {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    } else {
      // ignore: use_build_context_synchronously
      showSnackBar(
          context: context,
          content: res,
          bgColor: mobileSearchColor,
          textColor: primaryColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                    ),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 2,
                          child: Container(),
                        ),
                        SvgPicture.asset(
                          'assets/ic_instagram.svg',
                          colorFilter: const ColorFilter.mode(
                            primaryColor,
                            BlendMode.srcIn,
                          ),
                          height: MediaQuery.of(context).size.height * 0.067,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Stack(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage:
                                  image != null ? MemoryImage(image!) : null,
                              radius: 64,
                            ),
                            Positioned(
                              bottom: -10,
                              left: 80,
                              child: IconButton(
                                onPressed: pickImage,
                                icon: const Icon(
                                  Icons.add_a_photo,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFieldInput(
                          textEditingController: usernameController,
                          hintText: 'Enter your username',
                          textInputType: TextInputType.text,
                          maxLength: 30,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldInput(
                          textEditingController: emailController,
                          hintText: 'Enter your email',
                          textInputType: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFieldInput(
                          textEditingController: passwordController,
                          hintText: 'Enter your password',
                          textInputType: TextInputType.text,
                          isPass: true,
                          maxLength: 128,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldInput(
                          textEditingController: bioController,
                          hintText: 'Enter your bio',
                          textInputType: TextInputType.text,
                          isPass: false,
                          maxLength: 150,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        InkWell(
                          onTap: () => signUpUser(context),
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: const ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              color: blueColor,
                            ),
                            child: _isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: primaryColor,
                                    ),
                                  )
                                : const Text('Sign up'),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Container(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              child: const Text("Have an account?"),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            GestureDetector(
                              onTap: () => Navigator.of(context)
                                  .pushNamed(LoginScreen.routeName),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: const Text(
                                  " Sign in",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Flexible(
                          flex: 2,
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
