import 'lib/parking_lot_book/factories/vehicle_factory.dart';
import 'lib/parking_lot_book/services/parking_lot_manager.dart';
import 'lib/parking_lot_book/services/slot_allocation_strategy.dart';

void main() {
  print('Testing Parking Lot System...');

  try {
    // Get parking lot manager
    final parkingLot = ParkingLotManager.getInstance();

    // Initialize parking lot
    parkingLot.initializeParkingLot(
      floors: 2,
      rowsPerFloor: 3,
      slotsPerRow: 3,
      slotDistribution: {'small': 40, 'medium': 40, 'large': 20},
    );

    print('Parking lot initialized successfully!');

    // Create a vehicle
    final car = VehicleFactory.createCar(
      size: 'small',
      licensePlate: 'TEST123',
      color: 'Blue',
      entryTime: DateTime.now(),
    );

    print('Created car: ${car.licensePlate} (${car.getSizeCategory()})');

    // Set parking strategy
    parkingLot.setParkingStrategy(DefaultParkingStrategy());

    // Park the vehicle
    final gates = parkingLot.getEntryGates();
    final result = parkingLot.parkVehicle(car, gates.first.id);

    print('Parking result: ${result.message}');

    // Get statistics
    final stats = parkingLot.getParkingLotStatistics();
    print('Total slots: ${stats['totalSlots']}');
    print('Occupied slots: ${stats['occupiedSlots']}');

    print('All tests passed! ✅');
  } catch (e) {
    print('Error: $e');
  }
}
