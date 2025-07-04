// Presentation Layer: Simple State Management (without external BLoC package)

import 'dart:async';

import '../../domain/entities/vehicle_entities.dart';
import '../../domain/usecases/parking_usecases.dart';

class ParkingController {
  final ParkVehicleUseCase parkVehicleUseCase;
  final UnparkVehicleUseCase unparkVehicleUseCase;
  final GetAllSlotsUseCase getAllSlotsUseCase;
  final GetActiveTicketsUseCase getActiveTicketsUseCase;

  final StreamController<List<ParkingSlot>> _slotsController =
      StreamController<List<ParkingSlot>>.broadcast();
  final StreamController<List<ParkingTicket>> _ticketsController =
      StreamController<List<ParkingTicket>>.broadcast();
  final StreamController<String> _errorController =
      StreamController<String>.broadcast();
  final StreamController<String> _messageController =
      StreamController<String>.broadcast();

  Stream<List<ParkingSlot>> get slotsStream => _slotsController.stream;
  Stream<List<ParkingTicket>> get ticketsStream => _ticketsController.stream;
  Stream<String> get errorStream => _errorController.stream;
  Stream<String> get messageStream => _messageController.stream;

  String selectedPricingType = 'hourly';
  Timer? _pollTimer;

  ParkingController({
    required this.parkVehicleUseCase,
    required this.unparkVehicleUseCase,
    required this.getAllSlotsUseCase,
    required this.getActiveTicketsUseCase,
  }) {
    _startPollingSlots();
    loadInitialData();
  }

  void _startPollingSlots() {
    // Poll for slot updates every 5 seconds (in real app, this could be configurable)
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      refreshSlots();
    });
  }

  Future<void> loadInitialData() async {
    try {
      final slots = await getAllSlotsUseCase.execute();
      final tickets = await getActiveTicketsUseCase.execute();

      _slotsController.add(slots);
      _ticketsController.add(tickets);
    } catch (e) {
      _errorController.add('Failed to load data: $e');
    }
  }

  Future<void> refreshSlots() async {
    try {
      final slots = await getAllSlotsUseCase.execute();
      _slotsController.add(slots);
    } catch (e) {
      _errorController.add('Failed to refresh slots: $e');
    }
  }

  Future<void> parkVehicle(int slotId, Vehicle vehicle) async {
    try {
      final ticket = await parkVehicleUseCase.execute(slotId, vehicle);
      _messageController.add(
          'Vehicle ${vehicle.licensePlate} parked successfully in slot ${ticket.slotId}');
      await refreshSlots();
    } catch (e) {
      _errorController.add('Failed to park vehicle: $e');
      rethrow;
    }
  }

  Future<void> unparkVehicle(ParkingTicket ticket) async {
    try {
      final price =
          await unparkVehicleUseCase.execute(ticket, selectedPricingType);
      _messageController
          .add('Vehicle unparked. Total cost: \$${price.toStringAsFixed(2)}');
      await loadInitialData(); // Refresh data
    } catch (e) {
      _errorController.add('Failed to unpark vehicle: $e');
    }
  }

  void setPricingType(String type) {
    selectedPricingType = type;
    _messageController.add('Pricing type changed to $type');
  }

  void dispose() {
    _pollTimer?.cancel();
    _slotsController.close();
    _ticketsController.close();
    _errorController.close();
    _messageController.close();
  }
}
