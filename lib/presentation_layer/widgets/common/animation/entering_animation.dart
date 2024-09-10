import 'package:flutter/material.dart';
import 'package:flutter_application_test1/presentation_layer/providers/animation_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'entering_animation.dart';

class EntryTransition extends ConsumerStatefulWidget {
  final Widget child;
  final int position;

  const EntryTransition({Key? key, required this.child, required this.position}) : super(key: key);

  @override
  ConsumerState<EntryTransition> createState() => _EnteringTransitionState();
}

class _EnteringTransitionState extends ConsumerState<EntryTransition> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);

    _initAnimations();
    _controller.forward();

    // Schedule the callback registration after the build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(animationProvider.notifier).addExitCallback(() => _controller.reverse());
    });
  }

  @override
  void dispose() {
    // Ensure to clean up the registered callbacks
    ref.read(animationProvider.notifier).clearCallbacks();
    _controller.dispose();
    super.dispose();
  }

  void _initAnimations() {
    final intervalBegin = (widget.position - 1) * 0.1+0.1;
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
