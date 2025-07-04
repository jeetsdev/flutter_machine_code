import 'package:flutter/material.dart';

abstract class ParkingNotificationService {
  void showNotification(BuildContext context, String message);
}

class SnackbarParkingNotificationService implements ParkingNotificationService {
  @override
  void showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
