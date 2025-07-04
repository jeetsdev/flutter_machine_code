// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:test_app/parking_lot/domain/entities/parking_entities.dart';
// import 'package:test_app/parking_lot/injection/parking_injection.dart';
// import 'package:test_app/parking_lot/presentation/bloc/parking_bloc.dart';
// import 'package:test_app/parking_lot/presentation/bloc/parking_event.dart';
// import 'package:test_app/parking_lot/presentation/bloc/parking_state.dart';

// class SimpleParkingScreen extends StatelessWidget {
//   const SimpleParkingScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => ParkingDependencyInjection.getParkingBloc(),
//       child: BlocBuilder<ParkingBloc, ParkingState>(
//         builder: (context, state) {
//           if (state is ParkingLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (state is ParkingError) {
//             return Center(child: Text('Error: ${state.message}'));
//           }

//           if (state is ParkingLoaded) {
//             return Scaffold(
//               appBar: AppBar(
//                 title: const Text('Parking System'),
//                 backgroundColor: Colors.blue.shade800,
//                 foregroundColor: Colors.white,
//               ),
//               body: Column(
//                 children: [
//                   _buildSummaryCard(state),
//                   const SizedBox(height: 16),
//                   Expanded(child: _buildParkingGrid(context, state)),
//                 ],
//               ),
//             );
//           }

//           return const SizedBox.shrink();
//         },
//       ),
//     );
//   }

//   Widget _buildSummaryCard(ParkingLoaded state) {
//     final totalSlots = state.slots.length;
//     final occupiedSlots = state.slots.where((slot) => slot.isOccupied).length;
//     final availableSlots = totalSlots - occupiedSlots;
//     final trafficLevel = state.trafficLevel;

//     return Container(
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.blue.shade50,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildSummaryItem('Total', totalSlots.toString(), Colors.blue),
//           _buildSummaryItem(
//               'Available', availableSlots.toString(), Colors.green),
//           _buildSummaryItem(
//               'Occupied', occupiedSlots.toString(), Colors.orange),
//           _buildSummaryItem(
//             'Traffic',
//             '${(trafficLevel * 100).toInt()}%',
//             _getTrafficColor(trafficLevel),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getTrafficColor(double trafficLevel) {
//     if (trafficLevel > 0.8) return Colors.red;
//     if (trafficLevel > 0.6) return Colors.orange;
//     if (trafficLevel > 0.4) return Colors.yellow.shade700;
//     return Colors.green;
//   }

//   Widget _buildSummaryItem(String label, String value, Color color) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: color,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 14,
//             color: Colors.grey.shade700,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildParkingGrid(BuildContext context, ParkingLoaded state) {
//     return GridView.builder(
//       padding: const EdgeInsets.all(16),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 4,
//         childAspectRatio: 1,
//         crossAxisSpacing: 12,
//         mainAxisSpacing: 12,
//       ),
//       itemCount: state.slots.length,
//       itemBuilder: (context, index) => _buildParkingSlot(
//         context,
//         state.slots[index],
//       ),
//     );
//   }

//   Widget _buildParkingSlot(BuildContext context, ParkingSlot slot) {
//     return InkWell(
//       onTap: () => _handleSlotTap(context, slot),
//       child: Container(
//         decoration: BoxDecoration(
//           color: slot.isOccupied ? Colors.red.shade100 : Colors.green.shade100,
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(
//             color: slot.isOccupied ? Colors.red : Colors.green,
//             width: 2,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 4,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               slot.isOccupied ? Icons.directions_car : Icons.local_parking,
//               size: 32,
//               color: slot.isOccupied ? Colors.red : Colors.green,
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Slot ${slot.id}',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: slot.isOccupied
//                     ? Colors.red.shade700
//                     : Colors.green.shade700,
//               ),
//             ),
//             Text(
//               slot.isOccupied ? 'Occupied' : 'Available',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: slot.isOccupied
//                     ? Colors.red.shade700
//                     : Colors.green.shade700,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _handleSlotTap(BuildContext context, ParkingSlot slot) {
//     if (slot.isOccupied) {
//       final activeTickets =
//           (context.read<ParkingBloc>().state as ParkingLoaded).activeTickets;
//       final ticket = activeTickets.firstWhere(
//         (t) => t.slotId == slot.id,
//         orElse: () => ParkingTicket(slotId: slot.id, entryTime: DateTime.now()),
//       );

//       context.read<ParkingBloc>().add(UnparkVehicle(
//             ticket,
//             (context.read<ParkingBloc>().state as ParkingLoaded)
//                 .selectedPricingType,
//           ));
//     } else {
//       context.read<ParkingBloc>().add(ParkVehicle(slot.id));
//     }
//   }
// }
