import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/parking_lot_bloc.dart';

class OccupiedSlotsSection extends StatelessWidget {
  final ParkingLotLoaded state;

  const OccupiedSlotsSection({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final occupiedSlots = state.parkingLot.getOccupiedSlots();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Occupied Slots',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (occupiedSlots.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text('No occupied slots'),
              ),
            ),
          )
        else
          ...occupiedSlots.map((slot) {
            final vehicle = slot.parkedVehicle!;
            return Card(
              child: ListTile(
                title: Text('Slot ${slot.id} (${slot.size.name})'),
                subtitle: Text('Vehicle: ${vehicle.licensePlate}'),
                trailing: IconButton(
                  icon: const Icon(Icons.exit_to_app),
                  onPressed: () {
                    context
                        .read<ParkingLotBloc>()
                        .add(UnparkVehicle(vehicle.id));
                  },
                ),
              ),
            );
          }),
      ],
    );
  }
}
