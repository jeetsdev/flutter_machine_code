import 'package:flutter/material.dart';

import 'notification_observer.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final List<NotificationObserver> _observers = [];
  BuildContext? _context;

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  void setContext(BuildContext context) {
    _context = context;
  }

  void addObserver(NotificationObserver observer) {
    if (!_observers.contains(observer)) {
      _observers.add(observer);
    }
  }

  void removeObserver(NotificationObserver observer) {
    _observers.remove(observer);
  }

  void showNotification(String message) {
    // Notify all observers
    for (var observer in _observers) {
      observer.onNotification(message);
    }

    // Show snackbar if context is available
    if (_context != null) {
      ScaffoldMessenger.of(_context!).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
