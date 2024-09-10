import 'package:flutter/material.dart';
import 'package:flutter_application_test1/presentation_layer/providers/animation_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void navigateWithDelay(WidgetRef ref, BuildContext context, String routeName) async {
  ref.read(animationProvider.notifier).runExitAnimations();
  
  // Wait for the animation to complete
  await Future.delayed(const Duration(milliseconds: 1200));

  // Use GoRouter to navigate after the delay
  if (context.mounted) {
    context.goNamed(routeName);
  }
}