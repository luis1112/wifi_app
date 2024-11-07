import 'dart:async';

import 'package:flutter/material.dart';

class LongPressWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Function? onLongPress;

  const LongPressWidget({
    super.key,
    this.duration = const Duration(seconds: 3),
    required this.child,
    this.onLongPress,
  });

  @override
  State<LongPressWidget> createState() => _LongPressWidgetState();
}

class _LongPressWidgetState extends State<LongPressWidget> {
  Timer? _timer;
  bool _isPressed = false;

  void _startTimer() {
    _timer = Timer(widget.duration, _onLongPress);
  }

  void _onLongPress() {
    if (_isPressed) {
      if (widget.onLongPress != null) widget.onLongPress!();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        _isPressed = true;
        _startTimer();
      },
      onTapUp: (details) {
        _isPressed = false;
        _timer?.cancel();
      },
      onTapCancel: () {
        _isPressed = false;
        _timer?.cancel();
      },
      child: widget.child,
    );
  }
}
