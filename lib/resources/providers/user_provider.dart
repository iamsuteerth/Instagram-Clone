// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/auth_repository.dart';

final userProvider = StateNotifierProvider<UserProvider, UserModel?>((ref) {
  return UserProvider();
});

class UserProvider extends StateNotifier<UserModel?> {
  final AuthRepository _authRepository = AuthRepository();

  UserProvider() : super(null);

  Future<void> refreshUser() async {
    final user = await _authRepository.getUserDetails();
    state = user;
  }
}
