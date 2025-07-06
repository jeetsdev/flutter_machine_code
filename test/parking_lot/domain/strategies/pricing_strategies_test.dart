import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/parking_lot/domain/strategies/pricing_strategies.dart';

void main() {
  group('HourlyPricingStrategy', () {
    test('calculates price by hour (round up)', () {
      final strategy = HourlyPricingStrategy(5.0);
      expect(strategy.calculatePrice(const Duration(minutes: 61)), 10.0);
      expect(strategy.calculatePrice(const Duration(hours: 2)), 10.0);
      expect(strategy.strategyName, 'Hourly');
    });
  });

  group('DailyPricingStrategy', () {
    test('calculates price by day (round up)', () {
      final strategy = DailyPricingStrategy(40.0);
      expect(strategy.calculatePrice(const Duration(hours: 25)), 80.0);
      expect(strategy.calculatePrice(const Duration(days: 1)), 40.0);
      expect(strategy.strategyName, 'Daily');
    });
  });

  group('VipPricingStrategy', () {
    test('returns flat VIP rate', () {
      final strategy = VipPricingStrategy(100.0);
      expect(strategy.calculatePrice(const Duration(hours: 5)), 100.0);
      expect(strategy.strategyName, 'VIP');
    });
  });

  group('SurgePricingStrategy', () {
    test('applies surge multiplier', () {
      final base = HourlyPricingStrategy(5.0);
      final surge = SurgePricingStrategy(base, 1.5);
      expect(surge.calculatePrice(const Duration(hours: 2)), 15.0);
      expect(surge.strategyName, 'Hourly (Surge)');
    });
  });

  group('PricingCalculator', () {
    test('returns correct strategy and applies surge', () {
      final hourly = PricingCalculator.getPricingStrategy(
          type: 'hourly', trafficLevel: 0.9);
      expect(hourly is SurgePricingStrategy, true);
      expect(hourly.calculatePrice(const Duration(hours: 1)), 7.5);

      final daily = PricingCalculator.getPricingStrategy(
          type: 'daily', trafficLevel: 0.7);
      expect(daily is SurgePricingStrategy, true);
      expect(daily.calculatePrice(const Duration(days: 1)), 48.0);

      final vip =
          PricingCalculator.getPricingStrategy(type: 'vip', trafficLevel: 0.5);
      expect(vip is VipPricingStrategy, true);
      expect(vip.calculatePrice(const Duration(hours: 1)), 100.0);
    });
  });
}
