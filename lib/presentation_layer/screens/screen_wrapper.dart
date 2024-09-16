import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_test1/common_layer/theme/app_colors.dart';
import 'package:flutter_application_test1/common_layer/theme/app_theme.dart';
import 'package:flutter_application_test1/presentation_layer/providers/scroll_controller_provider.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/header_footer/bottom_navigation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/header_footer/new_top_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_test1/common_layer/theme/app_colors.dart';
import 'package:flutter_application_test1/presentation_layer/providers/scroll_controller_provider.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/header_footer/bottom_navigation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/header_footer/new_top_bar.dart';

class ScreenWrapper extends ConsumerStatefulWidget {
  final Widget child;

  const ScreenWrapper({super.key, required this.child});

  @override
  ConsumerState<ScreenWrapper> createState() => _ScreenWrapperState();
}

class _ScreenWrapperState extends ConsumerState<ScreenWrapper> {
  @override
  Widget build(BuildContext context) {
    // Retrieve the scroll controller from the provider
    final ScrollController _scrollController = ref.watch(scrollControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      extendBody: true,
      body: Column(
        children: [
          NewTopBar(controller: _scrollController),
          
          // Expanded to ensure the content fills the available space, allows scrolling within child screens
          Expanded(
            child: Container(
              color: AppColors.screenBackgroundColor,
              padding: EdgeInsets.only(
                top: GyminiTheme.verticalGapUnit*2,
                bottom: 100,
              ),
              child: widget.child,
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
