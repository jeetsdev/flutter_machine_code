void main() {
  List<ParkingSlot> smallParkingSlot =
      List.generate(3, (index) => SmallParkingSlot());
  List<ParkingSlot> mediumParkingSlot =
      List.generate(5, (index) => MediumParkingSlot());
  List<ParkingSlot> largeParkingSlot =
      List.generate(2, (index) => LargeParkingSlot());

  final parkingManager = ParkingManager();
  final smallCar = SmallCar(prioritySortList: [
    smallParkingSlot,
    mediumParkingSlot,
    largeParkingSlot
  ]);

  final mediumCar =
      MediumCar(prioritySortList: [mediumParkingSlot, largeParkingSlot]);

  final largeCar = LargeCar(prioritySortList: [largeParkingSlot]);

  print(parkingManager.parkCar(smallCar));
  print(parkingManager.parkCar(smallCar));
  print(parkingManager.parkCar(smallCar));
  print(parkingManager.parkCar(mediumCar));
  print(parkingManager.parkCar(largeCar));
}

abstract class Car {
  String get size;
  ParkingSlot? _slot;
  final List<List<ParkingSlot>?> prioritySortList;
  Car({required this.prioritySortList});

  bool parkInPriorityOrder(
    Car car,
  ) {
    for (var slots in prioritySortList) {
      for (var slot in slots!) {
        if (!slot.isOccupied && slot.canFit(car)) {
          slot.park(car);
          car.setParkingSlot(slot);
          return true;
        }
      }
    }
    return false;
  }

  void setParkingSlot(ParkingSlot slot) {
    _slot = slot;
  }

  ParkingSlot? get getParkedSlot => _slot;
}

class SmallCar extends Car {
  @override
  final List<List<ParkingSlot>?> prioritySortList;
  SmallCar({required this.prioritySortList})
      : super(prioritySortList: prioritySortList);
  @override
  String get size => "smallCar";
}

class MediumCar extends Car {
  @override
  final List<List<ParkingSlot>?> prioritySortList;
  MediumCar({required this.prioritySortList})
      : super(prioritySortList: prioritySortList);
  @override
  String get size => "mediumCar";
}

class LargeCar extends Car {
  @override
  final List<List<ParkingSlot>?> prioritySortList;
  LargeCar({required this.prioritySortList})
      : super(prioritySortList: prioritySortList);
  @override
  String get size => "largeCar";
}

abstract class ParkingSlot {
  String get slotSize => '';
  bool get isOccupied => _parkedCar == null;

  Car? _parkedCar;

  bool canFit(Car car);

  void park(Car car) {
    _parkedCar = car;
  }
}

class SmallParkingSlot extends ParkingSlot {
  @override
  String get slotSize => 'smallSlot';

  @override
  bool canFit(Car car) => car is SmallCar;
}

class MediumParkingSlot extends ParkingSlot {
  @override
  String get slotSize => 'mediumSlot';
  @override
  bool canFit(Car car) => car is SmallCar || car is MediumCar;
}

class LargeParkingSlot extends ParkingSlot {
  @override
  String get slotSize => 'largeSlot';
  @override
  bool canFit(Car car) =>
      car is SmallCar || car is MediumCar || car is LargeCar;
}

class ParkingManager {
  bool parkCar(Car car) {
    return car.parkInPriorityOrder(
      car,
    );
  }
}
