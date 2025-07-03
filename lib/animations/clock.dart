import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class RealTimeClock extends StatefulWidget {
  const RealTimeClock({super.key});

  @override
  _RealTimeClockState createState() => _RealTimeClockState();
}

class _RealTimeClockState extends State<RealTimeClock> {
  late Timer _timer;
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now(); // Update time every second
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Stop the timer when the widget is disposed
    super.dispose();
  }

  String _formattedTime() {
    return "${_currentTime.hour.toString().padLeft(2, '0')}:"
        "${_currentTime.minute.toString().padLeft(2, '0')}:"
        "${_currentTime.second.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          _formattedTime(),
          style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: RealTimeClock()));
}

class AnimatedClock extends StatefulWidget {
  const AnimatedClock({super.key});

  @override
  _AnimatedClockState createState() => _AnimatedClockState();
}

class _AnimatedClockState extends State<AnimatedClock>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration:
          const Duration(seconds: 60), // Completes a full revolution in 60s
    )..repeat(); // Loops forever
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              size: const Size(300, 300),
              painter: ClockPainter(_controller.value),
            );
          },
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  final double animationValue;

  ClockPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final Paint circlePaint = Paint()..color = Colors.black;
    final Paint centerDotPaint = Paint()..color = Colors.red;

    canvas.drawCircle(center, radius, circlePaint); // Draw clock face
    canvas.drawCircle(center, 5, centerDotPaint); // Center dot

    final DateTime now = DateTime.now();

    // Smooth seconds based on animationValue
    final double smoothSeconds =
        now.second + now.millisecond / 1000.0 + animationValue;
    final double secondAngle = (pi / 30) * smoothSeconds;

    final Paint secondHandPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final handLength = radius * 0.8;
    final secondHandOffset = center +
        Offset(handLength * sin(secondAngle), -handLength * cos(secondAngle));

    // Draw second hand
    canvas.drawLine(center, secondHandOffset, secondHandPaint);
  }

  @override
  bool shouldRepaint(covariant ClockPainter oldDelegate) {
    return true; // Continuously repaint for smooth motion
  }
}

// void main() {
//   runApp(MaterialApp(home: AnimatedClock()));
// }
