// import 'package:flutter/material.dart';

// import '../../application/services/notification_service.dart';
// import '../../application/services/snackbar_notification_observer.dart';
// import '../../application/usecases/park_vehicle_usecase.dart';
// import '../../application/usecases/unpark_vehicle_usecase.dart';
// import '../../data/datasources/parking_remote_datasource.dart';
// import '../../data/repositories/parking_repository_impl.dart';

// class ParkingScreen extends StatefulWidget {
//   const ParkingScreen({super.key});

//   @override
//   State<ParkingScreen> createState() => _ParkingScreenState();
// }

// class _ParkingScreenState extends State<ParkingScreen> {
//   late final ParkingRemoteDataSource _remoteDataSource;
//   late final ParkingRepositoryImpl _repository;
//   late final NotificationService _notificationService;
//   late final SnackBarNotificationObserver _notificationObserver;
//   late final ParkVehicleUseCase _parkVehicleUseCase;
//   late final UnparkVehicleUseCase _unparkVehicleUseCase;
//   final _vehicleController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _remoteDataSource = ParkingRemoteDataSource(baseUrl: 'YOUR_API_URL');
//     _repository = ParkingRepositoryImpl(_remoteDataSource);
//     _notificationService = NotificationService();
//     _parkVehicleUseCase = ParkVehicleUseCase(_repository, _notificationService);
//     _unparkVehicleUseCase =
//         UnparkVehicleUseCase(_repository, _notificationService);
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _notificationObserver = SnackBarNotificationObserver(context);
//     _notificationService.addObserver(_notificationObserver);
//   }

//   @override
//   void dispose() {
//     _vehicleController.dispose();
//     _notificationService.removeObserver(_notificationObserver);
//     super.dispose();
//   }

//   Future<void> _handleParkVehicle(int slotId) async {
//     final response = await _parkVehicleUseCase.execute(
//       slotId,
//       _vehicleController.text,
//     );

//     if (response.success) {
//       _vehicleController.clear();
//       setState(() {});
//     }
//   }

//   Future<void> _handleUnparkVehicle(int slotId) async {
//     final response = await _unparkVehicleUseCase.execute(slotId);
//     if (response.success) {
//       setState(() {});
//     }
//   }

//   Future<List<ParkingSlotModel>> _getSlots() async {
//     final response = await _repository.getAllSlots();
//     if (response.success) {
//       return response.data ?? [];
//     }
//     return [];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<ParkingSlotModel>>(
//         future: _getSlots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final slots = snapshot.data ?? [];
//           final availableSlots = slots.where((slot) => !slot.isOccupied).length;

//           return Scaffold(
//             appBar: AppBar(
//               title: const Text('Parking System'),
//             ),
//             body: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: TextField(
//                     controller: _vehicleController,
//                     decoration: const InputDecoration(
//                       labelText: 'Vehicle Number',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     'Available Slots: $availableSlots',
//                     style: Theme.of(context).textTheme.titleLarge,
//                   ),
//                 ),
//                 if (availableSlots == 0)
//                   const Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Text(
//                       'Parking Full!',
//                       style: TextStyle(
//                         color: Colors.red,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 Expanded(
//                   child: GridView.builder(
//                     padding: const EdgeInsets.all(16.0),
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       childAspectRatio: 3 / 2,
//                       crossAxisSpacing: 10,
//                       mainAxisSpacing: 10,
//                     ),
//                     itemCount: slots.length,
//                     itemBuilder: (context, index) {
//                       final slot = slots[index];
//                       return Card(
//                         color: slot.isOccupied
//                             ? Colors.red[100]
//                             : Colors.green[100],
//                         child: InkWell(
//                           onTap: () => slot.isOccupied
//                               ? _handleUnparkVehicle(slot.id)
//                               : _handleParkVehicle(slot.id),
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   'Slot ${slot.id}',
//                                   style:
//                                       Theme.of(context).textTheme.titleMedium,
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   slot.isOccupied
//                                       ? 'Occupied\n${slot.vehicleNumber}'
//                                       : 'Available',
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           );
//         });
//   }
// }
