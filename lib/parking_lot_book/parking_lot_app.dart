import 'package:flutter/material.dart';
import 'parking_lot_demo.dart' as demo;

class ParkingLotApp extends StatefulWidget {
  const ParkingLotApp({super.key});

  @override
  State<ParkingLotApp> createState() => _ParkingLotAppState();
}

class _ParkingLotAppState extends State<ParkingLotApp> {
  bool _isDemoRunning = false;
  String _demoOutput = '';

  Future<void> _runDemo() async {
    setState(() {
      _isDemoRunning = true;
      _demoOutput = 'Running parking lot demo...\n';
    });

    try {
      // Run the demo
      demo.main();
      setState(() {
        _demoOutput += 'Demo completed successfully!';
      });
    } catch (e) {
      setState(() {
        _demoOutput += 'Error running demo: $e';
      });
    } finally {
      setState(() {
        _isDemoRunning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking Lot Management System'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Smart Parking Lot Management System',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Features:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text('• Multiple entry gates'),
            const Text('• Smart slot assignment (small, medium, large)'),
            const Text('• Factory pattern for vehicle creation'),
            const Text('• Strategy pattern for payments & fares'),
            const Text('• Singleton pattern for parking lot management'),
            const Text('• SOLID principles implementation'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isDemoRunning ? null : _runDemo,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: _isDemoRunning
                  ? const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('Running Demo...'),
                      ],
                    )
                  : const Text('Run Parking Lot Demo'),
            ),
            const SizedBox(height: 16),
            if (_demoOutput.isNotEmpty)
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      _demoOutput,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
