// Single responsibility principle
class ProductService {
  void addProduct(
      Product product) {} // 1 reason :- if place where storing product changes
  void updateProduct(Product product) {}
  Product getProductById(Product product) {
    return Product();
  }

  void deleteProduct(Product product) {}
}

class TaxCalculate {
  double caltax(Product product) {
    return 0.1 * product.price;
  }
}

class Product {
  int price;
  Product() : price = 10;
}

// O

class User {
  // final String type;
  void userDoSomething() {}
}

class Admin extends User {
  @override
  void userDoSomething();
}

class Customer extends User {
  @override
  void userDoSomething();
}

class ManagerUser {
  userDoSomething(User user) {
    user.userDoSomething();
  }
}

// o
abstract class PaymentType {
  // final String type;

  void pay() {}
}

class PayPal implements PaymentType {
  @override
  void pay() {
    print("paypal");
  }
}

class Stripe implements PaymentType {
  @override
  void pay() {
    print("Stripe");
  }
}

class PaymentProcessor {
  void pay(PaymentType paymentType) {
    paymentType.pay();
  }
}

void main() {
  final PaymentType paymentType1 = PayPal();
  final PaymentType paymentType2 = Stripe();

  final PaymentProcessor paymentProcessor = PaymentProcessor();

  paymentProcessor.pay(paymentType1);
  paymentProcessor.pay(paymentType2);
}
