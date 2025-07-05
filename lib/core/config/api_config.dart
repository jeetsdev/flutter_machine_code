class ApiConfig {
  // API Base URL
  static const String baseUrl = 'https://api.parking.example.com';

  // API Endpoints
  static const String availableSlots = '/slots/available';
  static const String allSlots = '/slots';
  static const String parkVehicle = '/park';
  static const String unparkVehicle = '/unpark';
  static const String activeTickets = '/tickets/active';
  static const String trafficLevel = '/traffic';

  // API Timeouts
  static const int connectionTimeout = 15000; // 15 seconds
  static const int receiveTimeout = 15000; // 15 seconds
  static const int sendTimeout = 15000; // 15 seconds
}
