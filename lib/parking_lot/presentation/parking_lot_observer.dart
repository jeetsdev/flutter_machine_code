import 'package:flutter/material.dart';

import 'parking_notification_service.dart';

abstract class ParkingLotObserver {
  void onSlotBooked(BuildContext context, int slotId);
  void onSlotUnparked(BuildContext context, int slotId);
  void onFull(BuildContext context);
}

class NotificationParkingLotObserver implements ParkingLotObserver {
  final ParkingNotificationService notificationService;

  NotificationParkingLotObserver(this.notificationService);

  @override
  void onSlotBooked(BuildContext context, int slotId) {
    notificationService.showNotification(context, 'Slot $slotId booked!');
  }

  @override
  void onSlotUnparked(BuildContext context, int slotId) {
    notificationService.showNotification(context, 'Slot $slotId unparked!');
  }

  @override
  void onFull(BuildContext context) {
    notificationService.showNotification(context, 'All slots are full!');
  }
}
