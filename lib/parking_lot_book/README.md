# Parking Lot Management System

A comprehensive parking lot management system built with Dart, following SOLID principles and implementing various design patterns.

## Architecture & Design Patterns

### SOLID Principles Implementation

1. **Single Responsibility Principle (SRP)**
   - Each class has a single, well-defined responsibility
   - `Vehicle` classes handle vehicle-specific behavior
   - `ParkingSlot` classes handle slot-specific logic
   - `PaymentStrategy` classes handle payment processing
   - `FareStrategy` classes handle fare calculation

2. **Open/Closed Principle (OCP)**
   - Classes are open for extension but closed for modification
   - New vehicle types can be added by extending `Vehicle` class
   - New payment methods can be added by implementing `PaymentStrategy`
   - New fare strategies can be added by implementing `FareStrategy`

3. **Liskov Substitution Principle (LSP)**
   - All car classes (`SmallCar`, `MediumCar`, `LargeCar`) can be used interchangeably where `Vehicle` is expected
   - All parking slot classes can be used interchangeably where `ParkingSlot` is expected

4. **Interface Segregation Principle (ISP)**
   - Interfaces are specific and focused
   - `PaymentStrategy` interface only contains payment-related methods
   - `FareStrategy` interface only contains fare calculation methods

5. **Dependency Inversion Principle (DIP)**
   - High-level modules depend on abstractions, not concretions
   - `ParkingLotManager` depends on abstract `Vehicle` and `ParkingSlot` classes
   - `PaymentProcessor` depends on abstract `PaymentStrategy` interface

### Design Patterns

#### 1. Factory Pattern
- **VehicleFactory**: Creates different types of vehicles
- **ParkingSlotFactory**: Creates different types of parking slots
- Ensures consistent object creation and easy extension for new types

#### 2. Strategy Pattern
- **FareStrategy**: Different fare calculation strategies (Hourly, Daily, Premium)
- **PaymentStrategy**: Different payment methods (Cash, Credit Card, Digital Wallet)
- Allows runtime switching of algorithms

#### 3. Singleton Pattern
- **ParkingLotManager**: Ensures only one instance of parking lot exists
- Thread-safe implementation
- Global access point for parking lot operations

## Project Structure

```
lib/parking_lot_book/
├── models/
│   ├── vehicle.dart              # Abstract Vehicle class
│   ├── car_types.dart           # SmallCar, MediumCar, LargeCar classes
│   ├── car.dart                 # Deprecated - for backward compatibility
│   └── parking_slot_base.dart   # ParkingSlot classes
├── factories/
│   ├── vehicle_factory.dart     # Vehicle creation factory
│   └── parking_slot_factory.dart # Parking slot creation factory
├── strategies/
│   ├── fare_strategy.dart       # Fare calculation strategies
│   └── payment_strategy.dart    # Payment processing strategies
├── services/
│   └── parking_lot_manager.dart # Main parking lot management
└── parking_lot_demo.dart        # Demo/example usage
```

## Features

### Vehicle Management
- Multiple vehicle sizes: Small, Medium, Large
- Each size has different base fare rates
- Extensible for new vehicle types

### Smart Parking Algorithm
- Finds nearest available slot to entry gate
- Priority slot assignment:
  1. **Small cars**: First try small slots, then medium, then large
  2. **Medium cars**: First try medium slots, then large
  3. **Large cars**: Only large slots
- Ensures optimal space utilization

### Multiple Entry Gates
- Support for multiple entry points
- Smart slot assignment based on proximity to entry gate

### Flexible Fare Calculation
- **Hourly Strategy**: Standard hourly rates
- **Daily Strategy**: Discounted rates for longer stays
- **Premium Strategy**: Higher rates with additional services

### Multiple Payment Methods
- **Cash Payment**: Instant processing
- **Credit Card**: Validation and processing simulation
- **Digital Wallet**: PIN-based authentication

### Real-time Statistics
- Occupancy rates
- Slot distribution by size
- Available vs occupied slots
- Parked vehicle tracking

## Usage Example

```dart
import 'parking_lot_book/parking_lot_demo.dart';

void main() {
  // Run the demo to see the system in action
  parking_lot_demo.main();
}
```

### Basic Operations

```dart
// Get parking lot manager instance
final parkingLot = ParkingLotManager.getInstance();

// Initialize parking lot
parkingLot.initializeParkingLot(
  floors: 3,
  rowsPerFloor: 10,
  slotsPerRow: 10,
  slotDistribution: {'small': 40, 'medium': 40, 'large': 20},
);

// Create a vehicle
final car = VehicleFactory.createCar(
  size: 'small',
  licensePlate: 'ABC123',
  color: 'Red',
  entryTime: DateTime.now(),
);

// Park the vehicle
final result = parkingLot.parkVehicle(car, 'GATE_1');
print(result.message);

// Remove vehicle and calculate fare
final removeResult = parkingLot.removeVehicle('ABC123');
print('Fare: \$${removeResult['fare']}');
```

### Payment Processing

```dart
// Create payment processor with strategy
final processor = PaymentProcessor(CreditCardPaymentStrategy());

// Process payment
final result = await processor.processPayment(25.0, {
  'cardNumber': '1234567890123456',
  'cvv': '123',
  'expiryDate': '12/25',
});

print(result.message);
```

## Key Benefits

1. **Scalability**: Easy to add new vehicle types, payment methods, and fare strategies
2. **Maintainability**: Clean separation of concerns and well-defined interfaces
3. **Flexibility**: Runtime configuration of strategies and policies
4. **Reliability**: Singleton pattern ensures consistent state management
5. **Extensibility**: Factory patterns make it easy to add new types
6. **Testability**: Dependency injection and interface-based design enable easy testing

## Future Enhancements

- Reservation system
- VIP parking zones
- Electric vehicle charging stations
- Mobile app integration
- Real-time availability API
- Parking history and analytics
- Dynamic pricing based on demand
- Integration with payment gateways
