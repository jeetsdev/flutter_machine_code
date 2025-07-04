import '../models/vehicle.dart';

// Strategy Pattern for fare calculation
abstract class FareStrategy {
  double calculateFare(Vehicle vehicle, Duration parkedDuration);
}

// Hourly fare strategy
class HourlyFareStrategy implements FareStrategy {
  @override
  double calculateFare(Vehicle vehicle, Duration parkedDuration) {
    final hours = parkedDuration.inHours;
    final minutes = parkedDuration.inMinutes % 60;

    // Calculate total hours (including partial hours)
    final totalHours = hours + (minutes > 0 ? 1 : 0);

    return vehicle.calculateBaseFare() * totalHours;
  }
}

// Daily fare strategy (cheaper for long stays)
class DailyFareStrategy implements FareStrategy {
  @override
  double calculateFare(Vehicle vehicle, Duration parkedDuration) {
    final days = parkedDuration.inDays;
    final remainingHours = (parkedDuration.inHours % 24);

    final baseFare = vehicle.calculateBaseFare();
    final dailyRate =
        baseFare * 20; // 20 hours worth for a full day (4 hours discount)

    double totalFare = days * dailyRate;

    // Add remaining hours if any
    if (remainingHours > 0) {
      totalFare += baseFare * remainingHours;
    }

    return totalFare;
  }
}

// Premium fare strategy (higher rates but includes services)
class PremiumFareStrategy implements FareStrategy {
  @override
  double calculateFare(Vehicle vehicle, Duration parkedDuration) {
    final hours = parkedDuration.inHours;
    final minutes = parkedDuration.inMinutes % 60;

    // Calculate total hours (including partial hours)
    final totalHours = hours + (minutes > 0 ? 1 : 0);

    // Premium rate is 1.5x the base rate
    return vehicle.calculateBaseFare() * totalHours * 1.5;
  }
}

// Fare Calculator using Strategy Pattern
class FareCalculator {
  FareStrategy _strategy;

  FareCalculator(this._strategy);

  void setStrategy(FareStrategy strategy) {
    _strategy = strategy;
  }

  double calculateFare(Vehicle vehicle) {
    final parkedDuration = vehicle.getParkedDuration();
    return _strategy.calculateFare(vehicle, parkedDuration);
  }
}
