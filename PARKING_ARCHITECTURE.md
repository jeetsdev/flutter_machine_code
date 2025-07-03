# Parking Lot System - Clean Architecture Implementation

## Overview
This project implements a comprehensive parking lot management system using Clean Architecture principles and SOLID design patterns in Flutter. The system supports multiple pricing strategies including hourly, daily, VIP, and surge pricing based on traffic levels.

## Architecture

### Clean Architecture Layers

```
lib/parking_lot/
├── domain/                 # Business Logic Layer
│   ├── entities/          # Business entities
│   ├── repositories/      # Repository interfaces
│   ├── usecases/         # Business use cases
│   └── strategies/       # Pricing strategies
├── data/                  # Data Layer
│   └── repositories/     # Repository implementations
├── presentation/          # Presentation Layer
│   ├── screens/          # UI screens
│   ├── controllers/      # State management
│   └── bloc/            # BLoC patterns (optional)
└── injection/            # Dependency Injection
```

## SOLID Principles Implementation

### 1. Single Responsibility Principle (SRP)
- **ParkingSlot**: Represents only parking slot data
- **ParkingTicket**: Handles only ticket information
- **PricingStrategy**: Each strategy handles one pricing method
- **Use Cases**: Each use case handles one specific business operation

### 2. Open/Closed Principle (OCP)
- **PricingStrategy**: Abstract class allowing new pricing strategies without modifying existing code
- **Repository Pattern**: New data sources can be added without changing business logic

### 3. Liskov Substitution Principle (LSP)
- All pricing strategies can be substituted with any other strategy implementation
- Repository implementations can be swapped without affecting use cases

### 4. Interface Segregation Principle (ISP)
- **ParkingRepository**: Contains only parking-related methods
- Separated interfaces for different concerns

### 5. Dependency Inversion Principle (DIP)
- Use cases depend on repository abstractions, not implementations
- Presentation layer depends on use case abstractions
- Dependency injection manages all dependencies

## Features

### Pricing Strategies
1. **Hourly Pricing**: Standard hourly rate
2. **Daily Pricing**: Flat daily rate
3. **VIP Pricing**: Premium pricing for VIP slots
4. **Surge Pricing**: Dynamic pricing based on traffic levels
   - Traffic > 80%: 1.5x multiplier
   - Traffic > 60%: 1.2x multiplier

### Parking Management
- 60 total slots (50 regular + 10 VIP)
- Real-time slot availability tracking
- Active ticket management
- Traffic level monitoring

### User Interface
- Grid view of parking slots
- Real-time status updates
- Interactive parking/unparking
- Pricing strategy selection
- Summary dashboard

## File Structure

### Domain Layer
```dart
// entities/parking_entities.dart
class ParkingSlot {
  final int id;
  final bool isVip;
  bool isOccupied;
}

class ParkingTicket {
  final int slotId;
  final DateTime entryTime;
  DateTime? exitTime;
  double? price;
}
```

### Pricing Strategies
```dart
// strategies/pricing_strategies.dart
abstract class PricingStrategy {
  double calculatePrice(Duration duration);
  String get strategyName;
}

class HourlyPricingStrategy implements PricingStrategy { ... }
class DailyPricingStrategy implements PricingStrategy { ... }
class VipPricingStrategy implements PricingStrategy { ... }
class SurgePricingStrategy implements PricingStrategy { ... }
```

### Use Cases
```dart
// usecases/parking_usecases.dart
class ParkVehicleUseCase { ... }
class UnparkVehicleUseCase { ... }
class GetAvailableSlotsUseCase { ... }
class GetAllSlotsUseCase { ... }
```

### Repository Pattern
```dart
// repositories/parking_repository.dart
abstract class ParkingRepository {
  Future<List<ParkingSlot>> getAvailableSlots();
  Future<ParkingTicket> parkVehicle(int slotId);
  Future<double> unparkVehicle(ParkingTicket ticket);
  Stream<List<ParkingSlot>> watchSlots();
}
```

## Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.1.3    # State management
  equatable: ^2.0.5       # Value equality
```

## Usage

### Running the Application
```bash
flutter pub get
flutter run
```

### Navigation
1. Launch the app
2. Select "Parking Lot System" from the home screen
3. Interact with parking slots by tapping them

### Parking Operations
- **Park**: Tap an available (green) slot
- **Unpark**: Tap an occupied (red) slot and confirm
- **Change Pricing**: Use the dropdown in the app bar
- **View Tickets**: Tap the floating action button

## Design Patterns Used

1. **Strategy Pattern**: For pricing strategies
2. **Repository Pattern**: For data access abstraction
3. **Dependency Injection**: For managing dependencies
4. **Observer Pattern**: For real-time updates
5. **Factory Pattern**: For pricing strategy selection

## Benefits of This Architecture

1. **Testability**: Each layer can be tested independently
2. **Maintainability**: Easy to modify and extend
3. **Scalability**: New features can be added without affecting existing code
4. **Separation of Concerns**: Clear boundaries between layers
5. **Flexibility**: Easy to swap implementations

## Future Enhancements

1. **Persistence**: Add local/remote database
2. **Authentication**: User management system
3. **Payment Integration**: Payment processing
4. **Reporting**: Analytics and reporting features
5. **Notifications**: Real-time notifications
6. **API Integration**: Backend service integration

## Testing Strategy

```dart
// Example test structure
test/
├── domain/
│   ├── entities/
│   ├── usecases/
│   └── strategies/
├── data/
│   └── repositories/
└── presentation/
    └── controllers/
```

This architecture ensures the parking lot system is robust, maintainable, and follows industry best practices for Flutter development.
