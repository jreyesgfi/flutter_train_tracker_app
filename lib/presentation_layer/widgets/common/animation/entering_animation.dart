import 'package:flutter/material.dart';
import 'package:gymini/presentation_layer/providers/animation_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EntryTransition extends ConsumerStatefulWidget {
  final int position;
  final Widget child;
  final int totalAnimations;

  const EntryTransition({
    super.key,
    required this.position,
    required this.child,
    this.totalAnimations = 5,
  });

  @override
  ConsumerState<EntryTransition> createState() => _EnteringTransitionState();
}

class _EnteringTransitionState extends ConsumerState<EntryTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: 500+widget.totalAnimations*100), vsync: this);

    _initAnimations();
    _controller.forward();

    // Schedule the callback registration after the build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(animationProvider.notifier).addExitCallback(() {
          if (mounted) {
            _controller.reverse();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initAnimations() {
    final interval = (1/widget.totalAnimations);
    final intervalBegin = (widget.position - 1) * (interval/2) + 0.1;
    final intervalEnd = widget.position * interval;
    

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve:
            Interval(intervalBegin, intervalEnd, curve: Curves.fastOutSlowIn),
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
