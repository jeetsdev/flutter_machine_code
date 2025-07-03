// Domain Layer: Pricing Strategies

abstract class PricingStrategy {
  double calculatePrice(Duration duration);
  String get strategyName;
}

class HourlyPricingStrategy implements PricingStrategy {
  final double hourlyRate;

  HourlyPricingStrategy(this.hourlyRate);

  @override
  double calculatePrice(Duration duration) {
    return (duration.inHours.ceil()) * hourlyRate;
  }

  @override
  String get strategyName => 'Hourly';
}

class DailyPricingStrategy implements PricingStrategy {
  final double dailyRate;

  DailyPricingStrategy(this.dailyRate);

  @override
  double calculatePrice(Duration duration) {
    return (duration.inDays.ceil()) * dailyRate;
  }

  @override
  String get strategyName => 'Daily';
}

class VipPricingStrategy implements PricingStrategy {
  final double vipRate;

  VipPricingStrategy(this.vipRate);

  @override
  double calculatePrice(Duration duration) {
    // VIP could be a flat rate or have its own logic
    return vipRate;
  }

  @override
  String get strategyName => 'VIP';
}

class SurgePricingStrategy implements PricingStrategy {
  final PricingStrategy baseStrategy;
  final double surgeMultiplier;

  SurgePricingStrategy(this.baseStrategy, this.surgeMultiplier);

  @override
  double calculatePrice(Duration duration) {
    return baseStrategy.calculatePrice(duration) * surgeMultiplier;
  }

  @override
  String get strategyName => '${baseStrategy.strategyName} (Surge)';
}

abstract class PricingStrategyFactory {
  PricingStrategy createStrategy({
    required double trafficLevel,
    double hourlyRate = 5.0,
    double dailyRate = 40.0,
    double vipRate = 100.0,
  });
}

class HourlyPricingStrategyFactory implements PricingStrategyFactory {
  @override
  PricingStrategy createStrategy({
    required double trafficLevel,
    double hourlyRate = 5.0,
    double dailyRate = 40.0,
    double vipRate = 100.0,
  }) {
    PricingStrategy baseStrategy = HourlyPricingStrategy(hourlyRate);
    return _applySurgeIfNeeded(baseStrategy, trafficLevel);
  }
}

class DailyPricingStrategyFactory implements PricingStrategyFactory {
  @override
  PricingStrategy createStrategy({
    required double trafficLevel,
    double hourlyRate = 5.0,
    double dailyRate = 40.0,
    double vipRate = 100.0,
  }) {
    PricingStrategy baseStrategy = DailyPricingStrategy(dailyRate);
    return _applySurgeIfNeeded(baseStrategy, trafficLevel);
  }
}

class VipPricingStrategyFactory implements PricingStrategyFactory {
  @override
  PricingStrategy createStrategy({
    required double trafficLevel,
    double hourlyRate = 5.0,
    double dailyRate = 40.0,
    double vipRate = 100.0,
  }) {
    PricingStrategy baseStrategy = VipPricingStrategy(vipRate);
    return _applySurgeIfNeeded(baseStrategy, trafficLevel);
  }
}

PricingStrategy _applySurgeIfNeeded(PricingStrategy baseStrategy, double trafficLevel) {
  if (trafficLevel > 0.8) {
    return SurgePricingStrategy(baseStrategy, 1.5);
  } else if (trafficLevel > 0.6) {
    return SurgePricingStrategy(baseStrategy, 1.2);
  }
  return baseStrategy;
}

class PricingCalculator {
  static final Map<String, PricingStrategyFactory> _factories = {
    'hourly': HourlyPricingStrategyFactory(),
    'daily': DailyPricingStrategyFactory(),
    'vip': VipPricingStrategyFactory(),
  };

  static PricingStrategy getPricingStrategy({
    required String type,
    required double trafficLevel,
    double hourlyRate = 5.0,
    double dailyRate = 40.0,
    double vipRate = 100.0,
  }) {
    final factory = _factories[type.toLowerCase()] ?? HourlyPricingStrategyFactory();
    return factory.createStrategy(
      trafficLevel: trafficLevel,
      hourlyRate: hourlyRate,
      dailyRate: dailyRate,
      vipRate: vipRate,
    );
  }
}
