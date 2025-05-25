import 'package:flutter/material.dart';

class AnimatedLikeButton extends StatefulWidget {
  final bool isLiked;
  final int likeCount;
  final bool? isOwnQuote;
  final VoidCallback onPressed;

  const AnimatedLikeButton({
    super.key,
    required this.isLiked,
    required this.likeCount,
    this.isOwnQuote,
    required this.onPressed,
  });

  @override
  State<AnimatedLikeButton> createState() => _AnimatedLikeButtonState();
}

class _AnimatedLikeButtonState extends State<AnimatedLikeButton> with SingleTickerProviderStateMixin {
  // This helps us make the heart icon bigger and smaller.
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    widget.onPressed();
    _controller.forward().then((_) {
      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool showIconButton = widget.isOwnQuote != true;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showIconButton)
          ScaleTransition(
            scale: _animation,
            child: IconButton(
              icon: Icon(
                widget.isLiked ? Icons.favorite : Icons.favorite_border,
                color: widget.isLiked ? Colors.red : Theme.of(context).iconTheme.color,
              ),
              onPressed: _handleTap,
            ),
          ),
        Text(
          '${widget.likeCount} Likes',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}