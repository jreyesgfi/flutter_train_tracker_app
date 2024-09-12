import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_test1/common_layer/theme/app_colors.dart';
import 'package:flutter_application_test1/common_layer/theme/app_theme.dart';

class NewTopBar extends StatefulWidget {
  final ScrollController controller;

  NewTopBar({Key? key, required this.controller}) : super(key: key);

  @override
  _NewTopBarState createState() => _NewTopBarState();
}

class _NewTopBarState extends State<NewTopBar> {
  late double _fontSize;
  late Color _backgroundColor;
  late Color _shadowColor;
  late double _elevation;
  late double _borderRadius;
  late double _height;
  late double _bottomPadding;

  @override
  void initState() {
    super.initState();
    _fontSize = 23.0;
    _backgroundColor = AppColors.screenBackgroundColor; // Start with green
    _shadowColor = AppColors.screenBackgroundColor;
    _elevation = 0.0;
    _borderRadius = 0.0;
    _height = 120;
    _bottomPadding = 48;
    widget.controller.addListener(_updateAppBar);
  }

  void _updateAppBar() {
    double offset = widget.controller.offset.clamp(0.0, 80.0);
    setState(() {
      _fontSize = lerpDouble(23.0, 21.0, offset / 80.0)!;
      _backgroundColor = Color.lerp(AppColors.screenBackgroundColor,
          AppColors.whiteColor, offset / 80.0)!; // Transition to red
      _shadowColor = Color.lerp(AppColors.screenBackgroundColor,
          AppColors.darkColor.withOpacity(0.5), offset / 80)!;
      _borderRadius = lerpDouble(0.0, 50.0, offset / 80.0)!;
      _height = lerpDouble(120.0, 80.0, offset / 80.0)!;
      _bottomPadding = lerpDouble(48, 20.0, offset / 80.0)!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: _height + 50,
      floating: false,
      pinned: true,
      backgroundColor:
          AppColors.screenBackgroundColor, // Make background transparent
      elevation: 1,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
              color: AppColors.screenBackgroundColor,
              child: Container(
                height: _height,
                width: constraints.maxWidth,
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.only(
                    left: GyminiTheme.leftPadding, bottom: _bottomPadding),
                // Main container with the app background color
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: _shadowColor, // Custom shadow color
                      blurRadius: 8.0, // Soften the shadow
                      spreadRadius: 0.0, // Extend the shadow
                      offset: Offset(0, 2), // Position of the shadow
                    ),
                  ],
                  color: _backgroundColor,
                  borderRadius: BorderRadius.circular(_borderRadius),
                ),
                child: Text(
                  "Page Title", // First line for the month, day, year
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: _fontSize),
                ),
              ));
        },
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateAppBar);
    super.dispose();
  }
}
