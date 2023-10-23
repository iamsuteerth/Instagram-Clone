import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/dimensions.dart';

class ResponsiveLayoutScreen extends StatelessWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayoutScreen({
    super.key,
    required this.webScreenLayout,
    required this.mobileScreenLayout,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webScreenSize) {
          return webScreenLayout;
        }
        return mobileScreenLayout;
      },
    );
  }
}
