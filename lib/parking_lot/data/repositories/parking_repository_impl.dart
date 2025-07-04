import '../../domain/entities/entry_gate.dart';
import '../../domain/entities/parking_lot.dart';
import '../../domain/entities/parking_slot.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/entities/vehicle_size.dart';
import '../../domain/repositories/parking_repository.dart';
import '../../domain/strategies/slot_allocation_strategy.dart';
import '../datasources/parking_remote_datasource.dart';

class ParkingRepositoryImpl implements ParkingRepository {
  final ParkingRemoteDataSource remoteDataSource;
  final SlotAllocationStrategy slotAllocationStrategy;

  ParkingRepositoryImpl({
    required this.remoteDataSource,
    SlotAllocationStrategy? slotStrategy,
  }) : slotAllocationStrategy = slotStrategy ?? NearestSlotAllocationStrategy();

  @override
  Future<ParkingLot> getParkingLot() async {
    try {
      final response = await remoteDataSource.getParkingSlots();

      if (!response.success) {
        throw Exception(response.message);
      }

      final slots =
          response.data?.map((model) => model.toEntity()).toList() ?? [];

      // Create entry gates (you might want to make this a separate API call in a real app)
      final entryGates = [
        EntryGate(
          id: 'gate-a',
          name: 'Gate A - Main Entrance',
          nearbySlots: slots.where((slot) => slot.id.startsWith('A-')).toList(),
        ),
        EntryGate(
          id: 'gate-b',
          name: 'Gate B - Side Entrance',
          nearbySlots: slots.where((slot) => slot.id.startsWith('B-')).toList(),
        ),
        EntryGate(
          id: 'gate-c',
          name: 'Gate C - Back Entrance',
          nearbySlots: slots.where((slot) => slot.id.startsWith('C-')).toList(),
        ),
      ];

      return ParkingLot(
        id: 'main-parking-lot',
        name: 'Smart Parking Complex',
        entryGates: entryGates,
        allSlots: slots,
      );
    } catch (e) {
      throw Exception('Failed to get parking lot: ${e.toString()}');
    }
  }

  @override
  Future<ParkingSlot?> findNearestAvailableSlot(
      Vehicle vehicle, EntryGate entryGate) async {
    try {
      final parkingLot = await getParkingLot();
      return slotAllocationStrategy.allocate(
          parkingLot.allSlots, vehicle, entryGate);
    } catch (e) {
      throw Exception('Failed to find available slot: ${e.toString()}');
    }
  }

  @override
  Future<bool> parkVehicle(Vehicle vehicle, String slotId) async {
    try {
      final response = await remoteDataSource.parkVehicle(vehicle, slotId);
      if (!response.success) {
        throw Exception(response.message);
      }
      return response.data ?? false;
    } catch (e) {
      throw Exception('Failed to park vehicle: ${e.toString()}');
    }
  }

  @override
  Future<Vehicle?> unparkVehicle(String vehicleId) async {
    try {
      final response = await remoteDataSource.unparkVehicle(vehicleId);
      if (!response.success) {
        throw Exception(response.message);
      }
      if (response.data == null) return null;

      // Convert VehicleModel back to Vehicle entity
      return VehicleFactory.createVehicle(
        id: response.data!.id,
        licensePlate: response.data!.licensePlate,
        size: response.data!.size,
      );
    } catch (e) {
      throw Exception('Failed to unpark vehicle: ${e.toString()}');
    }
  }

  @override
  Future<List<ParkingSlot>> getAvailableSlots() async {
    try {
      final parkingLot = await getParkingLot();
      return parkingLot.getAvailableSlots();
    } catch (e) {
      throw Exception('Failed to get available slots: ${e.toString()}');
    }
  }

  @override
  Future<List<ParkingSlot>> getOccupiedSlots() async {
    try {
      final parkingLot = await getParkingLot();
      return parkingLot.getOccupiedSlots();
    } catch (e) {
      throw Exception('Failed to get occupied slots: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> getParkingLotStatus() async {
    try {
      final parkingLot = await getParkingLot();
      final availableSlots = parkingLot.getAvailableSlots();
      final occupiedSlots = parkingLot.getOccupiedSlots();

      final availableBySize = <String, int>{};
      final occupiedBySize = <String, int>{};

      for (final size in SlotSize.values) {
        availableBySize[size.name] =
            availableSlots.where((slot) => slot.size == size).length;
        occupiedBySize[size.name] =
            occupiedSlots.where((slot) => slot.size == size).length;
      }

      return {
        'totalCapacity': parkingLot.totalCapacity,
        'availableSlots': parkingLot.availableSlots,
        'occupiedSlots': parkingLot.occupiedSlots,
        'availableBySize': availableBySize,
        'occupiedBySize': occupiedBySize,
        'entryGates': parkingLot.entryGates.length,
      };
    } catch (e) {
      throw Exception('Failed to get parking lot status: ${e.toString()}');
    }
  }
}
