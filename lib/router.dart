import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/comments_screen.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/screens/search_screen.dart';
import 'package:instagram_clone/screens/signup_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case SignupScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      );
    case CommentsScreen.routeName:
      final postId = routeSettings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => CommentsScreen(
          postId: postId,
        ),
      );
    case SearchScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SearchScreen(),
      );
    case ProfileScreen.routeName:
      final uid = routeSettings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => ProfileScreen(
          uid: uid,
        ),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Text('Some error ocurred'),
        ),
      );
  }
}
