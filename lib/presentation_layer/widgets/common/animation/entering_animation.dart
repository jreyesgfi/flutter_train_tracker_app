import 'package:flutter/material.dart';

class EnteringTransition extends StatefulWidget {
  final Widget child;
  final int position;
  final bool reverse;

  const EnteringTransition({
    Key? key,
    required this.child,
    required this.position,
    this.reverse = false,
  }) : super(key: key);

  @override
  _EnteringTransitionState createState() => _EnteringTransitionState();
}

class _EnteringTransitionState extends State<EnteringTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _initAnimations();
    if (!widget.reverse) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _initAnimations() {
    final intervalBegin = (widget.position - 1) * 0.1;
    final intervalEnd = widget.position * 0.2;

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(intervalBegin, intervalEnd, curve: Curves.fastOutSlowIn),
      ),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(intervalBegin, intervalEnd, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}
