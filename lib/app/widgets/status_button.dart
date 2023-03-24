import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ja/app/widgets/ripple_animation.dart';

class StatusButton extends StatefulWidget {
  const StatusButton({
    super.key,
    required this.isConnected,
    required this.onPressed,
    this.title,
    required this.subtitle,
    this.hasError = false,
  });

  final bool isConnected;
  final VoidCallback onPressed;
  final String? title;
  final String subtitle;
  final bool hasError;

  @override
  StatusButtonState createState() => StatusButtonState();
}

class StatusButtonState extends State<StatusButton>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 150,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return Column(
      children: [
        GestureDetector(
          onTapDown: _tapDown,
          onTapUp: _tapUp,
          onTap: () {
            widget.onPressed();
          },
          child: Transform.scale(
            scale: _scale,
            child: _animatedButton(),
          ),
        ),
        const SizedBox(height: 20),
        Column(
          children: [
            if (widget.isConnected)
              const Text(
                "Connected",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (widget.hasError)
              Column(
                children: [
                  const Text("An Error Occurred"),
                  ElevatedButton(
                    onPressed: () {
                      widget.onPressed();
                    },
                    child: const Text("Try Again"),
                  ),
                ],
              ),
            if (!widget.hasError)
              Text(
                widget.subtitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _animatedButton() {
    var child = Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: widget.isConnected
            ? context.theme.colorScheme.primary
            : Colors.grey,
      ),
      child: Center(
        child: Icon(
          Icons.power_settings_new_rounded,
          size: 80,
          color: widget.isConnected ? Colors.black : Colors.grey.shade800,
        ),
      ),
    );
    if (widget.isConnected) {
      return Ripples(
        color: widget.isConnected
            ? context.theme.colorScheme.primary
            : context.theme.scaffoldBackgroundColor,
        size: 130,
        child: child,
      );
    }
    return child;
  }

  void _tapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _tapUp(TapUpDetails details) {
    _controller.reverse();
  }
}
