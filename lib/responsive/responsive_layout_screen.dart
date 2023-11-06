import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/resources/providers/user_provider.dart';
import 'package:instagram_clone/utils/global_variables.dart';

class ResponsiveLayoutScreen extends ConsumerStatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayoutScreen({
    super.key,
    required this.webScreenLayout,
    required this.mobileScreenLayout,
  });

  @override
  ConsumerState<ResponsiveLayoutScreen> createState() =>
      _ResponsiveLayoutScreenState();
}

class _ResponsiveLayoutScreenState
    extends ConsumerState<ResponsiveLayoutScreen> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    ref.read(userProvider.notifier).refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webScreenSize) {
          return widget.webScreenLayout;
        }
        return widget.mobileScreenLayout;
      },
    );
  }
}
