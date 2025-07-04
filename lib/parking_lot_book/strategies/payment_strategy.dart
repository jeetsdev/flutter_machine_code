// Strategy Pattern for payment processing
abstract class PaymentStrategy {
  Future<PaymentResult> processPayment(
      double amount, Map<String, dynamic> paymentDetails);
  String getPaymentMethodName();
}

// Payment result model
class PaymentResult {
  final bool success;
  final String? transactionId;
  final String message;
  final DateTime timestamp;

  PaymentResult({
    required this.success,
    this.transactionId,
    required this.message,
    required this.timestamp,
  });
}

// Cash payment strategy
class CashPaymentStrategy implements PaymentStrategy {
  @override
  Future<PaymentResult> processPayment(
      double amount, Map<String, dynamic> paymentDetails) async {
    // Simulate cash payment processing
    await Future.delayed(const Duration(milliseconds: 500));

    return PaymentResult(
      success: true,
      transactionId: 'CASH_${DateTime.now().millisecondsSinceEpoch}',
      message:
          'Cash payment of \$${amount.toStringAsFixed(2)} received successfully',
      timestamp: DateTime.now(),
    );
  }

  @override
  String getPaymentMethodName() => 'Cash';
}

// Credit card payment strategy
class CreditCardPaymentStrategy implements PaymentStrategy {
  @override
  Future<PaymentResult> processPayment(
      double amount, Map<String, dynamic> paymentDetails) async {
    // Simulate credit card processing
    await Future.delayed(const Duration(seconds: 2));

    final cardNumber = paymentDetails['cardNumber'] as String?;
    final cvv = paymentDetails['cvv'] as String?;
    final expiryDate = paymentDetails['expiryDate'] as String?;

    // Basic validation
    if (cardNumber == null || cvv == null || expiryDate == null) {
      return PaymentResult(
        success: false,
        message: 'Invalid card details provided',
        timestamp: DateTime.now(),
      );
    }

    // Simulate payment processing
    if (cardNumber.length >= 16 && cvv.length >= 3) {
      return PaymentResult(
        success: true,
        transactionId: 'CC_${DateTime.now().millisecondsSinceEpoch}',
        message:
            'Credit card payment of \$${amount.toStringAsFixed(2)} processed successfully',
        timestamp: DateTime.now(),
      );
    } else {
      return PaymentResult(
        success: false,
        message: 'Credit card payment failed - Invalid card details',
        timestamp: DateTime.now(),
      );
    }
  }

  @override
  String getPaymentMethodName() => 'Credit Card';
}

// Digital wallet payment strategy
class DigitalWalletPaymentStrategy implements PaymentStrategy {
  @override
  Future<PaymentResult> processPayment(
      double amount, Map<String, dynamic> paymentDetails) async {
    // Simulate digital wallet processing
    await Future.delayed(const Duration(seconds: 1));

    final walletId = paymentDetails['walletId'] as String?;
    final pin = paymentDetails['pin'] as String?;

    if (walletId == null || pin == null) {
      return PaymentResult(
        success: false,
        message: 'Invalid wallet credentials provided',
        timestamp: DateTime.now(),
      );
    }

    // Simulate payment processing
    return PaymentResult(
      success: true,
      transactionId: 'WALLET_${DateTime.now().millisecondsSinceEpoch}',
      message:
          'Digital wallet payment of \$${amount.toStringAsFixed(2)} processed successfully',
      timestamp: DateTime.now(),
    );
  }

  @override
  String getPaymentMethodName() => 'Digital Wallet';
}

// Payment processor using Strategy Pattern
class PaymentProcessor {
  PaymentStrategy _strategy;

  PaymentProcessor(this._strategy);

  void setPaymentMethod(PaymentStrategy strategy) {
    _strategy = strategy;
  }

  Future<PaymentResult> processPayment(
      double amount, Map<String, dynamic> paymentDetails) {
    return _strategy.processPayment(amount, paymentDetails);
  }

  String getCurrentPaymentMethod() {
    return _strategy.getPaymentMethodName();
  }
}
