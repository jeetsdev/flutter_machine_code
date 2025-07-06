import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/parking_lot/data/models/api_response.dart';

void main() {
  group('ApiResponse', () {
    test('should create ApiResponse with default values', () {
      final response = ApiResponse(data: {}, status: 'success', message: 'ok');
      expect(response.data, isA<Map>());
      expect(response.status, 'success');
      expect(response.message, 'ok');
      test('fromJson creates correct ApiResponse', () {
        final json = {
          'data': {'foo': 'bar'},
          'status': 'success',
          'message': 'done'
        };
        final response = ApiResponse.fromJson(json);
        expect(response.data, isA<Map>());
        expect(response.status, 'success');
        expect(response.message, 'done');
        expect(response.error, false);
      });
    });
  });
}
