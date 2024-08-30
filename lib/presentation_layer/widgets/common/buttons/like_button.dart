import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  final bool isLiked;
  final VoidCallback onLike;
  final double width;
  final double height;

  const LikeButton({
    Key? key,
    required this.isLiked,
    required this.onLike,
    this.width = 50.0,
    this.height = 50.0,
  }) : super(key: key);

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  late bool _isLiked;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 0),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        }
      });

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(covariant LikeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLiked != oldWidget.isLiked) {
      _isLiked = widget.isLiked;
    }
  }

  void _onTap() {
    setState(() {
      _isLiked = !_isLiked;
    });

    _controller.forward();

    widget.onLike();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.favorite,
              color: _isLiked ? Colors.red : Colors.grey,
              size: 20, // Initial and final size of the icon
            ),
            ScaleTransition(
              scale: _animation,
              child: Icon(
                Icons.favorite,
                color: _isLiked ? Colors.red : Colors.grey,
                size: 25, // This will scale up during the animation
              ),
            ),
          ],
        ),
      ),
    );
  }
}
