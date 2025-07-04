import 'factories/vehicle_factory.dart';
import 'services/parking_lot_manager.dart';
import 'strategies/fare_strategy.dart';
import 'strategies/payment_strategy.dart';
import 'services/slot_allocation_strategy.dart';

// Demo of the Parking Lot System
void main() async {
  print('=== Parking Lot Management System Demo ===\n');

  // Get singleton instance of parking lot manager
  final parkingLot = ParkingLotManager.getInstance();

  // Initialize parking lot
  print('1. Initializing Parking Lot...');
  parkingLot.initializeParkingLot(
    floors: 3,
    rowsPerFloor: 10,
    slotsPerRow: 10,
    slotDistribution: {
      'small': 40, // 40% small slots
      'medium': 40, // 40% medium slots
      'large': 20, // 20% large slots
    },
  );

  // Display initial statistics
  print('Initial Parking Lot Statistics:');
  printStatistics(parkingLot.getParkingLotStatistics());

  print('\n2. Creating vehicles using Factory Pattern...');

  // Create vehicles using Factory Pattern
  final smallCar1 = VehicleFactory.createCar(
    size: 'small',
    licensePlate: 'ABC123',
    color: 'Red',
    entryTime: DateTime.now(),
  );

  final mediumCar1 = VehicleFactory.createCar(
    size: 'medium',
    licensePlate: 'XYZ789',
    color: 'Blue',
    entryTime: DateTime.now(),
  );

  final largeCar1 = VehicleFactory.createCar(
    size: 'large',
    licensePlate: 'LMN456',
    color: 'Black',
    entryTime: DateTime.now(),
  );

  print('Created vehicles:');
  print(
      '- ${smallCar1.runtimeType}: ${smallCar1.licensePlate} (${smallCar1.color})');
  print(
      '- ${mediumCar1.runtimeType}: ${mediumCar1.licensePlate} (${mediumCar1.color})');
  print(
      '- ${largeCar1.runtimeType}: ${largeCar1.licensePlate} (${largeCar1.color})');

  print('\n3. Parking vehicles...');

  // Park vehicles
  final entryGates = parkingLot.getEntryGates();
  final gate1 = entryGates.first.id;

  // Park small car
  final smallCarResult = parkingLot.parkVehicle(smallCar1, gate1);
  print('Small car parking: ${smallCarResult.message}');

  // Park medium car
  final mediumCarResult = parkingLot.parkVehicle(mediumCar1, gate1);
  print('Medium car parking: ${mediumCarResult.message}');

  // Park large car
  final largeCarResult = parkingLot.parkVehicle(largeCar1, gate1);
  print('Large car parking: ${largeCarResult.message}');

  // Display updated statistics
  print('\nAfter parking 3 vehicles:');
  printStatistics(parkingLot.getParkingLotStatistics());

  print('\n4. Testing different fare strategies...');

  // Simulate some time passing
  await Future.delayed(const Duration(milliseconds: 100));

  // Test different fare strategies
  print('Using Hourly Fare Strategy:');
  parkingLot.setFareStrategy(HourlyFareStrategy());
  print(
      'Small car fare: \$${parkingLot.removeVehicle(smallCar1.licensePlate)['fare']?.toStringAsFixed(2)}');

  print('Using Daily Fare Strategy:');
  parkingLot.setFareStrategy(DailyFareStrategy());
  print(
      'Medium car fare: \$${parkingLot.removeVehicle(mediumCar1.licensePlate)['fare']?.toStringAsFixed(2)}');

  print('Using Premium Fare Strategy:');
  parkingLot.setFareStrategy(PremiumFareStrategy());
  print(
      'Large car fare: \$${parkingLot.removeVehicle(largeCar1.licensePlate)['fare']?.toStringAsFixed(2)}');

  print('\n5. Testing payment strategies...');

  // Test payment processing
  final paymentProcessor = PaymentProcessor(CashPaymentStrategy());

  // Cash payment
  print('Processing cash payment...');
  final cashResult = await paymentProcessor.processPayment(25.0, {});
  print('Cash payment result: ${cashResult.message}');

  // Credit card payment
  paymentProcessor.setPaymentMethod(CreditCardPaymentStrategy());
  print('Processing credit card payment...');
  final cardResult = await paymentProcessor.processPayment(30.0, {
    'cardNumber': '1234567890123456',
    'cvv': '123',
    'expiryDate': '12/25',
  });
  print('Credit card payment result: ${cardResult.message}');

  // Digital wallet payment
  paymentProcessor.setPaymentMethod(DigitalWalletPaymentStrategy());
  print('Processing digital wallet payment...');
  final walletResult = await paymentProcessor.processPayment(35.0, {
    'walletId': 'user@example.com',
    'pin': '1234',
  });
  print('Digital wallet payment result: ${walletResult.message}');

  print('\n6. Testing parking strategy...');

  // Test Default Strategy
  print('Using Default Parking Strategy:');
  parkingLot.setParkingStrategy(DefaultParkingStrategy());
  final strategyCar1 = VehicleFactory.createCar(
    size: 'small',
    licensePlate: 'STRAT1',
    color: 'Blue',
    entryTime: DateTime.now(),
  );
  final defaultResult = parkingLot.parkVehicle(strategyCar1, gate1);
  print('Default strategy result: ${defaultResult.message}');

  // Test Nearest Strategy
  print('Using Nearest Parking Strategy:');
  parkingLot.setParkingStrategy(
      NearestParkingStrategy(entryFloor: 1, entryRow: 1, entryColumn: 1));
  final strategyCar2 = VehicleFactory.createCar(
    size: 'medium',
    licensePlate: 'STRAT2',
    color: 'Gold',
    entryTime: DateTime.now(),
  );
  final nearestResult = parkingLot.parkVehicle(strategyCar2, gate1);
  print('Nearest strategy result: ${nearestResult.message}');

  print('\n7. Testing slot assignment logic...');

  // Test the smart slot assignment (small car can use larger slots if small ones are full)
  final manySmallCars = <dynamic>[];
  for (int i = 1; i <= 5; i++) {
    final car = VehicleFactory.createCar(
      size: 'small',
      licensePlate: 'SMALL$i',
      color: 'White',
      entryTime: DateTime.now(),
    );
    final result = parkingLot.parkVehicle(car, gate1);
    manySmallCars.add(car);
    print('Parking SMALL$i: ${result.message}');
  }

  // Final statistics
  print('\nFinal Parking Lot Statistics:');
  printStatistics(parkingLot.getParkingLotStatistics());

  print('\n=== Demo Complete ===');
}

void printStatistics(Map<String, dynamic> stats) {
  print('Total Slots: ${stats['totalSlots']}');
  print(
      'Occupied: ${stats['occupiedSlots']}, Available: ${stats['availableSlots']}');
  print('Occupancy Rate: ${stats['occupancyRate']}%');

  final distribution = stats['slotDistribution'] as Map<String, dynamic>;
  print('Slot Distribution:');
  distribution.forEach((size, data) {
    final sizeData = data as Map<String, dynamic>;
    print('  $size: ${sizeData['occupied']}/${sizeData['total']} occupied');
  });

  print('Parked Vehicles: ${stats['parkedVehicles']}');
  print('Entry Gates: ${stats['entryGates']}');
  print('');
}
