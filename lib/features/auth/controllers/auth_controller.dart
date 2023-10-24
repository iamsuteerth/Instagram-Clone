import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/features/auth/repository/auth_repository.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(
    authRepositoryProvider,
  );
  return AuthController(
    authRepository: authRepository,
    ref: ref,
  );
});

class AuthController {
  final ProviderRef ref;
  final AuthRepository authRepository;

  AuthController({
    required this.authRepository,
    required this.ref,
  });

  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) {
    authRepository.signUpUser(
      context: context,
      email: email,
      password: password,
      username: username,
      bio: bio,
      file: file,
    );
  }
}
