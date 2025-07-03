import 'dart:async';

import 'package:flutter/material.dart';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});

  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  Timer? _timer;
  String _timeDisplay = "00:00:00";
  bool _isRunning = false;

  // Custom stopwatch variables
  DateTime? _startTime;
  int _elapsedMilliseconds = 0;
  int _previousElapsedTime = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (_isRunning && _startTime != null) {
        setState(() {
          int currentElapsed =
              DateTime.now().difference(_startTime!).inMilliseconds;
          _elapsedMilliseconds = _previousElapsedTime + currentElapsed;
          _timeDisplay = _formatTime(_elapsedMilliseconds);
        });
      }
    });
  }

  String _formatTime(int milliseconds) {
    int hundredths = (milliseconds / 10).truncate();
    int seconds = (hundredths / 100).truncate();
    int minutes = (seconds / 60).truncate();

    hundredths = hundredths % 100;
    seconds = seconds % 60;
    minutes = minutes % 60;

    return "${minutes.toString().padLeft(2, '0')}:"
        "${seconds.toString().padLeft(2, '0')}:"
        "${hundredths.toString().padLeft(2, '0')}";
  }

  void _startStopwatch() {
    setState(() {
      _isRunning = true;
      _startTime = DateTime.now();
    });
    _startTimer();
  }

  void _pauseStopwatch() {
    if (_startTime != null) {
      // Calculate and store the elapsed time before pausing
      int currentElapsed =
          DateTime.now().difference(_startTime!).inMilliseconds;
      _previousElapsedTime = _previousElapsedTime + currentElapsed;
    }

    setState(() {
      _isRunning = false;
      _startTime = null;
    });
    _timer?.cancel();
  }

  void _resumeStopwatch() {
    setState(() {
      _isRunning = true;
      _startTime = DateTime.now();
    });
    _startTimer();
  }

  void _resetStopwatch() {
    setState(() {
      _isRunning = false;
      _timeDisplay = "00:00:00";
      _startTime = null;
      _elapsedMilliseconds = 0;
      _previousElapsedTime = 0;
    });
    _timer?.cancel();
  }

  bool get _hasStarted => _elapsedMilliseconds > 0 || _isRunning;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text(
          'Custom Stopwatch',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Time Display
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Text(
                _timeDisplay,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'monospace',
                ),
              ),
            ),

            const SizedBox(height: 60),

            // Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Start/Pause/Resume Button
                _buildControlButton(
                  onPressed: !_hasStarted
                      ? _startStopwatch
                      : _isRunning
                          ? _pauseStopwatch
                          : _resumeStopwatch,
                  icon: !_hasStarted
                      ? Icons.play_arrow
                      : _isRunning
                          ? Icons.pause
                          : Icons.play_arrow,
                  color: !_hasStarted
                      ? Colors.green
                      : _isRunning
                          ? Colors.orange
                          : Colors.green,
                  label: !_hasStarted
                      ? 'START'
                      : _isRunning
                          ? 'PAUSE'
                          : 'RESUME',
                ),

                // Reset Button
                _buildControlButton(
                  onPressed: _resetStopwatch,
                  icon: Icons.refresh,
                  color: Colors.red,
                  label: 'RESET',
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Status Indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: _isRunning
                    ? Colors.green.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _isRunning ? Colors.green : Colors.grey,
                  width: 2,
                ),
              ),
              child: Text(
                _isRunning ? 'RUNNING' : 'STOPPED',
                style: TextStyle(
                  color: _isRunning ? Colors.green : Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Debug Info (optional - shows elapsed milliseconds)
            if (_hasStarted)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Total: ${_elapsedMilliseconds}ms',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required VoidCallback onPressed,
    required IconData icon,
    required Color color,
    required String label,
  }) {
    return Column(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: const CircleBorder(),
              elevation: 8,
              shadowColor: color.withOpacity(0.4),
            ),
            child: Icon(icon, size: 30, color: Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
