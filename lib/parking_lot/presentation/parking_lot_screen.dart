import 'package:flutter/material.dart';

import '../application/parking_lot_service.dart';
import '../data/parking_lot_repository_impl.dart';
import '../domain/parking_slot.dart';
import 'parking_lot_observer.dart';
import 'parking_notification_service.dart';

class ParkingLotScreen extends StatefulWidget {
  const ParkingLotScreen({super.key});

  @override
  State<ParkingLotScreen> createState() => _ParkingLotScreenState();
}

class _ParkingLotScreenState extends State<ParkingLotScreen> {
  late final ParkingLotService _service;
  late final ParkingNotificationService _notificationService;
  late final ParkingLotObserver _observer;
  final TextEditingController _vehicleController = TextEditingController();
  int? _selectedSlotId;

  @override
  void initState() {
    super.initState();
    _service = ParkingLotService(ParkingLotRepositoryImpl());
    _notificationService = SnackbarParkingNotificationService();
    _observer = NotificationParkingLotObserver(_notificationService);
  }

  void _bookSlot() {
    final error = _service.bookSlot(_selectedSlotId, _vehicleController.text);
    if (error == null) {
      _observer.onSlotBooked(context, _selectedSlotId!);
      setState(() {});
    } else {
      _notificationService.showNotification(context, error);
    }
  }

  void _unparkSlot(int slotId) {
    final error = _service.unparkSlot(slotId);
    if (error == null) {
      _observer.onSlotUnparked(context, slotId);
      setState(() {});
    } else {
      _notificationService.showNotification(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final slots = _service.getAllSlots();
    final isFull = _service.isFull();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isFull) {
        _observer.onFull(context);
      }
    });
    return Scaffold(
      appBar: AppBar(title: const Text('Parking Lot System')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButton<int>(
                    value: _selectedSlotId,
                    hint: const Text('Select Slot'),
                    items: slots
                        .where((s) => s.status == SlotStatus.available)
                        .map((slot) => DropdownMenuItem(
                              value: slot.id,
                              child: Text('Slot ${slot.id}'),
                            ))
                        .toList(),
                    onChanged: isFull
                        ? null
                        : (id) => setState(() => _selectedSlotId = id),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _vehicleController,
                    decoration: const InputDecoration(
                      labelText: 'Vehicle Number',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: isFull ? null : _bookSlot,
                  child: const Text('Book'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: slots.length,
                itemBuilder: (context, index) {
                  final slot = slots[index];
                  return Card(
                    color: slot.status == SlotStatus.occupied
                        ? Colors.red[100]
                        : Colors.green[100],
                    child: ListTile(
                      title: Text('Slot ${slot.id}'),
                      subtitle: Text(slot.status == SlotStatus.occupied
                          ? 'Occupied by ${slot.vehicleNumber}'
                          : 'Available'),
                      trailing: slot.status == SlotStatus.occupied
                          ? IconButton(
                              icon: const Icon(Icons.exit_to_app),
                              onPressed: () => _unparkSlot(slot.id),
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _vehicleController.dispose();
    super.dispose();
  }
}
