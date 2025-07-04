import 'package:flutter/material.dart';

import '../bloc/parking_lot_bloc.dart';

class ParkingStatusCard extends StatelessWidget {
  final ParkingLotLoaded state;

  const ParkingStatusCard({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Parking Lot Status',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            StatusRow(
              label: 'Total Capacity',
              value: state.status['totalCapacity'].toString(),
            ),
            StatusRow(
              label: 'Available Slots',
              value: state.status['availableSlots'].toString(),
            ),
            StatusRow(
              label: 'Occupied Slots',
              value: state.status['occupiedSlots'].toString(),
            ),
            const Divider(),
            const Text(
              'Available by Size:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizeStatusSection(sizeStatus: state.status['availableBySize']),
          ],
        ),
      ),
    );
  }
}

class StatusRow extends StatelessWidget {
  final String label;
  final String value;

  const StatusRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class SizeStatusSection extends StatelessWidget {
  final Map<String, dynamic> sizeStatus;

  const SizeStatusSection({
    super.key,
    required this.sizeStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: sizeStatus.entries.map((entry) {
        return StatusRow(
          label: '${entry.key.toUpperCase()} slots',
          value: entry.value.toString(),
        );
      }).toList(),
    );
  }
}
