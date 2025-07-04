// import 'package:test/test.dart';
// import '../lib/parking_lot_book/factories/vehicle_factory.dart';
// import '../lib/parking_lot_book/factories/parking_slot_factory.dart';
// import '../lib/parking_lot_book/services/parking_lot_manager.dart';
// import '../lib/parking_lot_book/strategies/fare_strategy.dart';
// import '../lib/parking_lot_book/strategies/payment_strategy.dart';
// import '../lib/parking_lot_book/models/parking_slot_base.dart';

// void main() {
//   group('Parking Lot System Tests', () {
//     late ParkingLotManager parkingLot;

//     setUp(() {
//       parkingLot = ParkingLotManager.getInstance();
//       parkingLot.initializeParkingLot(
//         floors: 2,
//         rowsPerFloor: 5,
//         slotsPerRow: 5,
//         slotDistribution: {'small': 40, 'medium': 40, 'large': 20},
//       );
//     });

//     group('Vehicle Factory Tests', () {
//       test('should create small car correctly', () {
//         final car = VehicleFactory.createCar(
//           size: 'small',
//           licensePlate: 'TEST123',
//           color: 'Blue',
//           entryTime: DateTime.now(),
//         );

//         expect(car.getSizeCategory(), equals('small'));
//         expect(car.licensePlate, equals('TEST123'));
//         expect(car.color, equals('Blue'));
//         expect(car.calculateBaseFare(), equals(10.0));
//       });

//       test('should create medium car correctly', () {
//         final car = VehicleFactory.createCar(
//           size: 'medium',
//           licensePlate: 'MED456',
//           color: 'Red',
//           entryTime: DateTime.now(),
//         );

//         expect(car.getSizeCategory(), equals('medium'));
//         expect(car.calculateBaseFare(), equals(15.0));
//       });

//       test('should create large car correctly', () {
//         final car = VehicleFactory.createCar(
//           size: 'large',
//           licensePlate: 'LRG789',
//           color: 'Black',
//           entryTime: DateTime.now(),
//         );

//         expect(car.getSizeCategory(), equals('large'));
//         expect(car.calculateBaseFare(), equals(20.0));
//       });

//       test('should throw error for invalid car size', () {
//         expect(
//           () => VehicleFactory.createCar(
//             size: 'invalid',
//             licensePlate: 'ERR000',
//             color: 'White',
//             entryTime: DateTime.now(),
//           ),
//           throwsArgumentError,
//         );
//       });
//     });

//     group('Parking Slot Factory Tests', () {
//       test('should create small parking slot correctly', () {
//         final slot = ParkingSlotFactory.createSlot(
//           size: 'small',
//           id: 'S1',
//           status: SlotStatus.available,
//           floor: 1,
//           row: 1,
//           column: 1,
//         );

//         expect(slot.getSizeCategory(), equals('small'));
//         expect(slot.canAccommodateVehicle('small'), isTrue);
//         expect(slot.canAccommodateVehicle('medium'), isFalse);
//       });

//       test('should create medium parking slot correctly', () {
//         final slot = ParkingSlotFactory.createSlot(
//           size: 'medium',
//           id: 'M1',
//           status: SlotStatus.available,
//           floor: 1,
//           row: 1,
//           column: 2,
//         );

//         expect(slot.getSizeCategory(), equals('medium'));
//         expect(slot.canAccommodateVehicle('small'), isTrue);
//         expect(slot.canAccommodateVehicle('medium'), isTrue);
//         expect(slot.canAccommodateVehicle('large'), isFalse);
//       });

//       test('should create large parking slot correctly', () {
//         final slot = ParkingSlotFactory.createSlot(
//           size: 'large',
//           id: 'L1',
//           status: SlotStatus.available,
//           floor: 1,
//           row: 1,
//           column: 3,
//         );

//         expect(slot.getSizeCategory(), equals('large'));
//         expect(slot.canAccommodateVehicle('small'), isTrue);
//         expect(slot.canAccommodateVehicle('medium'), isTrue);
//         expect(slot.canAccommodateVehicle('large'), isTrue);
//       });
//     });

//     group('Parking Lot Manager Tests', () {
//       test('should park vehicle successfully', () {
//         final car = VehicleFactory.createCar(
//           size: 'small',
//           licensePlate: 'PARK123',
//           color: 'Green',
//           entryTime: DateTime.now(),
//         );

//         final result = parkingLot.parkVehicle(car, 'GATE_1');
        
//         expect(result.success, isTrue);
//         expect(result.assignedSlot, isNotNull);
//         expect(result.message, contains('parked successfully'));
//       });

//       test('should not park same vehicle twice', () {
//         final car = VehicleFactory.createCar(
//           size: 'small',
//           licensePlate: 'DUP123',
//           color: 'Yellow',
//           entryTime: DateTime.now(),
//         );

//         parkingLot.parkVehicle(car, 'GATE_1');
//         final result2 = parkingLot.parkVehicle(car, 'GATE_1');
        
//         expect(result2.success, isFalse);
//         expect(result2.message, contains('already parked'));
//       });

//       test('should calculate fare correctly on vehicle removal', () {
//         final car = VehicleFactory.createCar(
//           size: 'medium',
//           licensePlate: 'FARE123',
//           color: 'Purple',
//           entryTime: DateTime.now().subtract(Duration(hours: 2)),
//         );

//         parkingLot.parkVehicle(car, 'GATE_1');
//         final result = parkingLot.removeVehicle('FARE123');
        
//         expect(result['success'], isTrue);
//         expect(result['fare'], isA<double>());
//         expect(result['fare'], greaterThan(0));
//       });
//     });

//     group('Fare Strategy Tests', () {
//       test('hourly fare strategy should calculate correctly', () {
//         final strategy = HourlyFareStrategy();
//         final car = VehicleFactory.createCar(
//           size: 'small',
//           licensePlate: 'HOUR123',
//           color: 'Orange',
//           entryTime: DateTime.now().subtract(Duration(hours: 3)),
//         );

//         final fare = strategy.calculateFare(car, Duration(hours: 3));
//         expect(fare, equals(30.0)); // 10.0 base * 3 hours
//       });

//       test('daily fare strategy should provide discount', () {
//         final strategy = DailyFareStrategy();
//         final car = VehicleFactory.createCar(
//           size: 'small',
//           licensePlate: 'DAY123',
//           color: 'Pink',
//           entryTime: DateTime.now().subtract(Duration(days: 1)),
//         );

//         final fare = strategy.calculateFare(car, Duration(days: 1));
//         expect(fare, equals(200.0)); // 10.0 base * 20 (daily rate)
//       });
//     });

//     group('Payment Strategy Tests', () {
//       test('cash payment should process successfully', () async {
//         final strategy = CashPaymentStrategy();
//         final result = await strategy.processPayment(25.0, {});
        
//         expect(result.success, isTrue);
//         expect(result.transactionId, isNotNull);
//         expect(result.message, contains('Cash payment'));
//       });

//       test('credit card payment should validate details', () async {
//         final strategy = CreditCardPaymentStrategy();
        
//         // Valid card details
//         final validResult = await strategy.processPayment(50.0, {
//           'cardNumber': '1234567890123456',
//           'cvv': '123',
//           'expiryDate': '12/25',
//         });
//         expect(validResult.success, isTrue);
        
//         // Invalid card details
//         final invalidResult = await strategy.processPayment(50.0, {
//           'cardNumber': '123',
//           'cvv': '1',
//           'expiryDate': '12/25',
//         });
//         expect(invalidResult.success, isFalse);
//       });
//     });

//     group('Integration Tests', () {
//       test('complete parking workflow should work end-to-end', () async {
//         // Create and park vehicle
//         final car = VehicleFactory.createCar(
//           size: 'large',
//           licensePlate: 'E2E123',
//           color: 'Silver',
//           entryTime: DateTime.now().subtract(Duration(hours: 1)),
//         );

//         final parkResult = parkingLot.parkVehicle(car, 'GATE_1');
//         expect(parkResult.success, isTrue);

//         // Remove vehicle and get fare
//         final removeResult = parkingLot.removeVehicle('E2E123');
//         expect(removeResult['success'], isTrue);
        
//         final fare = removeResult['fare'] as double;
        
//         // Process payment
//         final paymentProcessor = PaymentProcessor(CreditCardPaymentStrategy());
//         final paymentResult = await paymentProcessor.processPayment(fare, {
//           'cardNumber': '1234567890123456',
//           'cvv': '123',
//           'expiryDate': '12/25',
//         });
        
//         expect(paymentResult.success, isTrue);
//         expect(paymentResult.transactionId, isNotNull);
//       });

//       test('smart slot assignment should work for small cars', () {
//         // Create multiple small cars
//         final cars = List.generate(3, (index) =>
//           VehicleFactory.createCar(
//             size: 'small',
//             licensePlate: 'SMART$index',
//             color: 'Blue',
//             entryTime: DateTime.now(),
//           ),
//         );

//         // Park all cars
//         for (final car in cars) {
//           final result = parkingLot.parkVehicle(car, 'GATE_1');
//           expect(result.success, isTrue);
//         }

//         // Check statistics
//         final stats = parkingLot.getParkingLotStatistics();
//         expect(stats['parkedVehicles'], equals(3));
//         expect(stats['occupiedSlots'], equals(3));
//       });
//     });
//   });
// }
