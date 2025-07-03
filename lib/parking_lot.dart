// ========== ENUMS ==========
enum CarSize { small, medium, large }

enum SlotSize { small, medium, large }

// ========== CAR INTERFACES & CLASSES ==========
abstract class Car {
  CarSize get size;
  List<SlotSize> get preferredSlots;
}

class SmallCar implements Car {
  @override
  CarSize get size => CarSize.small;

  @override
  List<SlotSize> get preferredSlots =>
      [SlotSize.small, SlotSize.medium, SlotSize.large];
}

class MediumCar implements Car {
  @override
  CarSize get size => CarSize.medium;

  @override
  List<SlotSize> get preferredSlots => [SlotSize.medium, SlotSize.large];
}

class LargeCar implements Car {
  @override
  CarSize get size => CarSize.large;

  @override
  List<SlotSize> get preferredSlots => [SlotSize.large];
}

// ========== SLOT INTERFACES & CLASSES ==========
abstract class ParkingSlot {
  SlotSize get size;
  Car? _car;

  bool get isOccupied => _car != null;

  bool canFit(Car car);

  void park(Car car) {
    _car = car;
  }

  void unpark() {
    _car = null;
  }

  Car? get parkedCar => _car;
}

class SmallParkingSlot extends ParkingSlot {
  @override
  SlotSize get size => SlotSize.small;

  @override
  bool canFit(Car car) => car.size == CarSize.small;
}

class MediumParkingSlot extends ParkingSlot {
  @override
  SlotSize get size => SlotSize.medium;

  @override
  bool canFit(Car car) =>
      car.size == CarSize.small || car.size == CarSize.medium;
}

class LargeParkingSlot extends ParkingSlot {
  @override
  SlotSize get size => SlotSize.large;

  @override
  bool canFit(Car car) => true; // All sizes
}

// ========== PARKING STRATEGY ==========
abstract class ParkingStrategy {
  ParkingSlot? findSlot(Car car, Map<SlotSize, List<ParkingSlot>> slots);
}

class DefaultParkingStrategy implements ParkingStrategy {
  @override
  ParkingSlot? findSlot(Car car, Map<SlotSize, List<ParkingSlot>> slots) {
    for (var preferredSize in car.preferredSlots) {
      final availableSlots = slots[preferredSize] ?? [];
      for (var i = 0; i < availableSlots.length; i++) {
        if (!availableSlots[i].isOccupied && availableSlots[i].canFit(car)) {
          return availableSlots[i];
        }
      }
    }
    return null;
  }
}

// ========== PARKING MANAGER ==========
class ParkingManager {
  final Map<SlotSize, List<ParkingSlot>> slots;
  final ParkingStrategy strategy;

  ParkingManager(this.slots, this.strategy);

  bool parkCar(Car car) {
    final slot = strategy.findSlot(car, slots);
    if (slot != null) {
      slot.park(car);
      print('${car.runtimeType} parked in ${slot.size} slot');
      return true;
    } else {
      print('No available slot for ${car.runtimeType}');
      return false;
    }
  }
}

void main() {
  final slots = {
    SlotSize.small: List.generate(3, (_) => SmallParkingSlot()),
    SlotSize.medium: List.generate(5, (_) => MediumParkingSlot()),
    SlotSize.large: List.generate(2, (_) => LargeParkingSlot()),
  };

  final manager = ParkingManager(slots, DefaultParkingStrategy());

  final smallCar = SmallCar();
  final mediumCar = MediumCar();
  final largeCar = LargeCar();

  manager.parkCar(smallCar); // small -> small
  manager.parkCar(smallCar); // small -> small
  manager.parkCar(smallCar); // small -> small
  manager.parkCar(smallCar); // small -> medium
  manager.parkCar(mediumCar); // medium -> medium
  manager.parkCar(largeCar); // large -> large
}
