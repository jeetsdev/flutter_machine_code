import 'package:flutter/material.dart';

import '../bloc/parking_lot_bloc.dart';

class EntryGatesSection extends StatelessWidget {
  final ParkingLotLoaded state;

  const EntryGatesSection({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Entry Gates',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...state.parkingLot.entryGates.map((gate) {
          return Card(
            child: ListTile(
              title: Text(gate.name),
              subtitle: Text('ID: ${gate.id}'),
              trailing: Text('${gate.nearbySlots.length} nearby slots'),
            ),
          );
        }),
      ],
    );
  }
}
