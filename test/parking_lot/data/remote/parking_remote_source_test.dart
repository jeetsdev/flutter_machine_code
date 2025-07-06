import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/core/network/dio_client.dart';
import 'package:test_app/core/network/injection.dart';
import 'package:test_app/parking_lot/data/remote/parking_remote_source.dart';

class MockDioClient extends Mock implements DioClient {}

class MockDio extends Mock implements Dio {}

void main() {
  late DioClient dioClient;
  late MockDio mockDio;

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  setUp(() {
    dioClient = MockDioClient();  
    mockDio = MockDio();
    when(() => dioClient.dio).thenReturn(mockDio);
    sl.reset();
    sl.registerSingleton<DioClient>(dioClient);
    sl.registerFactory(() => ParkingRemoteSource(sl()));
  });

  group('ParkingRemoteSource', () {
    test('should be instantiated', () {
      final repository = sl<ParkingRemoteSource>();
      print("here");
      expect(repository, isNotNull);
    });
  });
}



// // test/parking_repository_test.dart
// import 'package:dio/dio.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';

// import 'package:your_project/data/repositories/parking_repository.dart';
// import 'package:your_project/core/network/dio_client.dart';
// import 'package:your_project/core/di/injection.dart';


// class MockDioClient extends Mock implements DioClient {}

// void main() {
//   late MockDioClient mockClient;
//   late MockDio mockDio;

//   setUpAll(() {
//     registerFallbackValue(RequestOptions(path: ''));
//   });

//   setUp(() {
//     mockClient = MockDioClient();
//     mockDio = MockDio();

//     when(() => mockClient.dio).thenReturn(mockDio);

//     // override the singleton
//     sl.reset();
//     sl.registerSingleton<DioClient>(mockClient);
//     sl.registerFactory(() => ParkingRepository(sl()));
//   });

//   test('fetchSlots returns stringified data', () async {
//     final repository = sl<ParkingRepository>();

//     when(() => mockDio.get(any())).thenAnswer(
//       (_) async => Response(
//         data: {'slots': ['A1', 'A2']},
//         requestOptions: RequestOptions(path: '/parking-slots'),
//       ),
//     );

//     final result = await repository.fetchSlots();

//     expect(result, contains('A1'));
//     verify(() => mockDio.get('/parking-slots')).called(1);
//   });
// }