// Domain Layer: Use Cases

import 'package:test_app/parking_lot/domain/entities/parking_entities.dart';
import 'package:test_app/parking_lot/domain/repositories/parking_repository.dart';
import 'package:test_app/parking_lot/domain/strategies/pricing_strategies.dart';

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
      await repository.unparkVehicle(ticket);
      
      return price;
    } catch (e) {
      throw Exception('Failed to unpark vehicle: $e');
    }
  }
}
