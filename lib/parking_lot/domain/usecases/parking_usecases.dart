// Domain Layer: Use Cases

import '../entities/vehicle_entities.dart';
import '../repositories/parking_repository.dart';
import '../strategies/pricing_strategies.dart';

class ParkVehicleUseCase {
  final ParkingRepository repository;

  ParkVehicleUseCase(this.repository);

  Future<ParkingTicket> execute(int slotId, Vehicle vehicle) async {
    try {
      final availableSlots = await repository.getAvailableSlots();
      final slot = availableSlots.firstWhere(
        (slot) => slot.id == slotId,
        orElse: () => throw Exception('Slot $slotId is not available'),
      );

      if (!vehicle.canFitInSlot(slot)) {
        throw Exception('Vehicle cannot be parked in this slot type/size');
      }

      return await repository.parkVehicle(slotId, vehicle);
    } catch (e) {
      throw Exception('Failed to park vehicle: $e');
    }
  }
}

class UnparkVehicleUseCase {
  final ParkingRepository repository;

  UnparkVehicleUseCase(this.repository);

  Future<double> execute(ParkingTicket ticket, String pricingType) async {
    try {
      final trafficLevel = await repository.getTrafficLevel();
      final duration = DateTime.now().difference(ticket.entryTime);

      final pricingStrategy = PricingCalculator.getPricingStrategy(
        type: pricingType,
        trafficLevel: trafficLevel,
      );

      final price = pricingStrategy.calculatePrice(duration);
      ticket.copyWith(
        exitTime: DateTime.now(),
        price: price,
      );
      await repository.unparkVehicle(ticket);

      return price;
    } catch (e) {
      throw Exception('Failed to unpark vehicle: $e');
    }
  }
}

class GetAvailableSlotsUseCase {
  final ParkingRepository repository;

  GetAvailableSlotsUseCase(this.repository);

  Future<List<ParkingSlot>> execute() async {
    try {
      return await repository.getAvailableSlots();
    } catch (e) {
      throw Exception('Failed to get available slots: $e');
    }
  }
}

class GetAllSlotsUseCase {
  final ParkingRepository repository;

  GetAllSlotsUseCase(this.repository);

  Future<List<ParkingSlot>> execute() async {
    try {
      return await repository.getAllSlots();
    } catch (e) {
      throw Exception('Failed to get all slots: $e');
    }
  }
}

class GetActiveTicketsUseCase {
  final ParkingRepository repository;

  GetActiveTicketsUseCase(this.repository);

  Future<List<ParkingTicket>> execute() async {
    try {
      return await repository.getActiveTickets();
    } catch (e) {
      throw Exception('Failed to get active tickets: $e');
    }
  }
}
