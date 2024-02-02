import 'package:flutter/material.dart';

enum AnimationDirection { leftToright, rightToleft, topTobottom, bottomTotop }

class CustomSlideUpAndFadeWidget extends StatefulWidget {
  const CustomSlideUpAndFadeWidget(
      {super.key,
      required this.child,
      this.duration,
      this.curve,
      this.point = 0.1,
      this.direction = AnimationDirection.bottomTotop});
  final Widget child;
  final Duration? duration;
  final Curve? curve;
  final AnimationDirection direction;
  final double point;

  @override
  State<CustomSlideUpAndFadeWidget> createState() =>
      _CustomSlideUpAndFadeWidgetState();
}

class _CustomSlideUpAndFadeWidgetState extends State<CustomSlideUpAndFadeWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late Animation<double> _fadeAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? const Duration(milliseconds: 700),
      vsync: this,
    )..forward();

    _animation = Tween<Offset>(
      begin: Offset(
        widget.direction == AnimationDirection.bottomTotop
            ? 0.0
            : widget.direction == AnimationDirection.topTobottom
                ? 0.0
                : widget.direction == AnimationDirection.leftToright
                    ? -widget.point
                    : widget.direction == AnimationDirection.rightToleft
                        ? widget.point
                        : 0.0,
        widget.direction == AnimationDirection.bottomTotop
            ? widget.point
            : widget.direction == AnimationDirection.topTobottom
                ? -widget.point
                : widget.direction == AnimationDirection.leftToright
                    ? 0.0
                    : widget.direction == AnimationDirection.rightToleft
                        ? 0.0
                        : 0.0,
      ),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve ?? Curves.ease,
    ));

    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve ?? Curves.ease,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _animation,
        transformHitTests: true,
        child: widget.child,
      ),
    );
  }
}
