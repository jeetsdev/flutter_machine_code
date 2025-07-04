import 'package:flutter/material.dart';

import 'notification_observer.dart';

class SnackBarNotificationObserver implements NotificationObserver {
  final BuildContext context;

  SnackBarNotificationObserver(this.context);

  @override
  void onNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
