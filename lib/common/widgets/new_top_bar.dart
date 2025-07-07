import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gymini/common_layer/theme/app_colors.dart';
import 'package:gymini/common_layer/theme/app_theme.dart';
import 'package:gymini/app/router/navitation_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewTopBar extends ConsumerStatefulWidget {
  final ScrollController controller;

  const NewTopBar({super.key, required this.controller});

  @override
  ConsumerState<NewTopBar> createState() => _NewTopBarState();
}

class _NewTopBarState extends ConsumerState<NewTopBar>
    with TickerProviderStateMixin {
  late double _fontSize;
  late Color _backgroundColor;
  late double _borderRadius;
  late double _height;
  late double _bottomPadding;
  String _lastRouteLabel = ''; // Default initial value

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fontSize = 26.0;
    _backgroundColor = AppColors.screenBackgroundColor;
    _borderRadius = 0.0;
    _height = 80;
    _bottomPadding = 12;
    widget.controller.addListener(_updateAppBar);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0).animate(_fadeController);
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, 0.3))
            .animate(_slideController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Use BuildContext to retrieve the current route label.
    _lastRouteLabel = NavigationUtils.getRouteLabel(ref);
  }

  void _updateAppBar() {
    double offset = widget.controller.offset.clamp(0.0, 60.0);
    setState(() {
      _fontSize = lerpDouble(26.0, 21.0, offset / 60.0)!;
      _backgroundColor = Color.lerp(AppColors.screenBackgroundColor,
          AppColors.whiteColor, offset / 60.0)!;
      _borderRadius = lerpDouble(0.0, 20.0, offset / 60.0)!;
      _height = lerpDouble(80.0, 60.0, offset / 60.0)!;
      _bottomPadding = lerpDouble(16, 12.0, offset / 60.0)!;
      
    });
  }

  @override
  void didUpdateWidget(NewTopBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    final currentLabel = NavigationUtils.getRouteLabel(ref);
    if (currentLabel != _lastRouteLabel) {
      _fadeController.forward().then((_) {
        _fadeController.reverse();
        _slideController.reverse();
      });
      _slideController.forward();
      _lastRouteLabel = currentLabel;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  margin: const EdgeInsets.only(top: 4, left: 4, right: 4),
                  decoration: BoxDecoration(
                    color: _backgroundColor,
                    borderRadius: BorderRadius.circular(_borderRadius),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: GyminiTheme.leftOuterPadding,
                          bottom: _bottomPadding),
                      child: Text(
                        _lastRouteLabel,
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontWeight: FontWeight.bold,
                          fontSize: _fontSize,
                        ),
                        key: ValueKey<String>(_lastRouteLabel),
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
  void dispose() {
    widget.controller.removeListener(_updateAppBar);
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }
}
