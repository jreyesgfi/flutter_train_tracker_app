import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gymini/common_layer/theme/app_colors.dart';
import 'package:gymini/common_layer/theme/app_theme.dart';
import 'package:gymini/presentation_layer/providers/route_provider.dart';
import 'package:gymini/presentation_layer/router/navitation_utils.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';
import 'package:gymini/common_layer/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NewTopBar extends ConsumerStatefulWidget {
  final ScrollController controller;

  NewTopBar({Key? key, required this.controller}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewTopBarState();
}

class _NewTopBarState extends ConsumerState<NewTopBar> with TickerProviderStateMixin{
  late double _fontSize;
  late Color _backgroundColor;
  late Color _shadowColor;
  late double _elevation;
  late double _borderRadius;
  late double _height;
  late double _bottomPadding;

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fontSize = 26.0;
    _backgroundColor = AppColors.screenBackgroundColor; // Start with green
    _shadowColor = AppColors.screenBackgroundColor;
    _elevation = 0.0;
    _borderRadius = 0.0;
    _height = 120;
    _bottomPadding = 32;
    widget.controller.addListener(_updateAppBar);

    // Initialize animation controllers and animations
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0).animate(_fadeController);
    _slideAnimation = Tween<Offset>(begin: Offset(0, 0), end: Offset(0, 0.3)).animate(_slideController);
  }

  void _updateAppBar() {
    double offset = widget.controller.offset.clamp(0.0, 80.0);
    setState(() {
      _fontSize = lerpDouble(26.0, 21.0, offset / 80.0)!;
      _backgroundColor = Color.lerp(AppColors.screenBackgroundColor,
          AppColors.whiteColor, offset / 80.0)!; // Transition to red
      _shadowColor = Color.lerp(AppColors.screenBackgroundColor,
          AppColors.darkColor.withOpacity(0.5), offset / 80)!;
      _borderRadius = lerpDouble(0.0, 50.0, offset / 80.0)!;
      _height = lerpDouble(120.0, 80.0, offset / 80.0)!;
      _bottomPadding = lerpDouble(32, 20.0, offset / 80.0)!;
    });
  }

  @override
  Widget build(BuildContext context) {
    // React to changes in the route name from the provider
    final routeName = NavigationUtils.getRouteLabel(ref);

    return Container(
      height: _height,
      color: AppColors.screenBackgroundColor,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  margin: EdgeInsets.only(top: 20, left: 4, right: 4),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: _shadowColor,
                        blurRadius: 8.0,
                        spreadRadius: 0.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                    color: _backgroundColor,
                    borderRadius: BorderRadius.circular(_borderRadius),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: GyminiTheme.leftOuterPadding, bottom: _bottomPadding),
                      child: Text(
                        routeName,
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontWeight: FontWeight.bold,
                          fontSize: _fontSize,
                        ),
                        key: ValueKey<String>(routeName),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  @override
  void didUpdateWidget(NewTopBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Trigger animation when the routeName changes
    if (NavigationUtils.getRouteLabel(ref) != oldWidget.controller) {
      _fadeController.forward().then((_) {
        // Change the value after fade-out and reverse the fade/slide animation
        _fadeController.reverse();
        _slideController.reverse();
      });
      _slideController.forward();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateAppBar);
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }
}
