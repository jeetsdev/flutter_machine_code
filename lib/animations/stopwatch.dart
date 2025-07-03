import 'package:flutter/material.dart';

class StopwatchApp extends StatefulWidget {
  const StopwatchApp({super.key});

  @override
  _StopwatchAppState createState() => _StopwatchAppState();
}

class _StopwatchAppState extends State<StopwatchApp>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isRunning = false;
  Duration _elapsedTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(hours: 1), // Arbitrary long duration
    )..addListener(() {
        setState(() {}); // Rebuild UI on animation updates
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startStopwatch() {
    if (_isRunning) {
      _controller.stop();
      setState(() {
        _elapsedTime += _controller.lastElapsedDuration ?? Duration.zero;
      });
    } else {
      _controller.forward(from: _elapsedTime.inMilliseconds.toDouble());
    }
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  void _resetStopwatch() {
    _controller.stop();
    _controller.reset();
    setState(() {
      _isRunning = false;
      _elapsedTime = Duration.zero;
    });
  }

  String _formatTime(Duration duration) {
    final totalMilliseconds = (_elapsedTime + duration).inMilliseconds;
    final minutes = (totalMilliseconds ~/ 60000).toString().padLeft(2, '0');
    final seconds =
        ((totalMilliseconds ~/ 1000) % 60).toString().padLeft(2, '0');
    final milliseconds =
        ((totalMilliseconds ~/ 10) % 100).toString().padLeft(2, '0');
    return "$minutes:$seconds:$milliseconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stopwatch")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              _formatTime(_controller.lastElapsedDuration ?? Duration.zero),
              style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _startStopwatch,
                child: Text(_isRunning ? "Pause" : "Start"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _resetStopwatch,
                child: const Text("Reset"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class StopwatchApp extends StatefulWidget {
//   const StopwatchApp({super.key});

//   @override
//   _StopwatchAppState createState() => _StopwatchAppState();
// }

// class _StopwatchAppState extends State<StopwatchApp>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   Duration _elapsedTime = Duration.zero;
//   bool _isRunning = false;
//   bool _isPaused = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(days: 1), // Long duration for stopwatch
//     )..addListener(() {
//         setState(() {});
//       });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _start() {
//     _controller.forward(from: 0);
//     _isRunning = true;
//     _isPaused = false;
//   }

//   void _pause() {
//     _controller.stop();
//     _elapsedTime += _controller.lastElapsedDuration ?? Duration.zero;
//     _isPaused = true;
//   }

//   void _resume() {
//     _controller.forward(from: 0);
//     _isPaused = false;
//   }

//   void _stop() {
//     _controller.stop();
//     _controller.reset();
//     _elapsedTime = Duration.zero;
//     _isRunning = false;
//     _isPaused = false;
//   }

//   String _formatTime(Duration duration) {
//     final totalMs = (_elapsedTime + duration).inMilliseconds;
//     final minutes = (totalMs ~/ 60000).toString().padLeft(2, '0');
//     final seconds = ((totalMs ~/ 1000) % 60).toString().padLeft(2, '0');
//     final milliseconds = ((totalMs ~/ 10) % 100).toString().padLeft(2, '0');
//     return "$minutes:$seconds:$milliseconds";
//   }

//   @override
//   Widget build(BuildContext context) {
//     final current = _controller.lastElapsedDuration ?? Duration.zero;

//     return Scaffold(
//       appBar: AppBar(title: const Text("Stopwatch")),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Center(
//             child: Text(
//               _formatTime(current),
//               style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
//             ),
//           ),
//           const SizedBox(height: 30),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               if (!_isRunning) // Start
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(() => _start());
//                   },
//                   child: const Text("Start"),
//                 ),
//               if (_isRunning && !_isPaused) // Pause
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(() => _pause());
//                   },
//                   child: const Text("Pause"),
//                 ),
//               if (_isRunning && _isPaused) // Resume
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(() => _resume());
//                   },
//                   child: const Text("Resume"),
//                 ),
//               const SizedBox(width: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   setState(() => _stop());
//                 },
//                 child: const Text("Stop"),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
