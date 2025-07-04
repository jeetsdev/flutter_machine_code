import 'package:flutter/material.dart';

import '../../domain/entities/vehicle_entities.dart';

class VehicleDetailsDialog extends StatefulWidget {
  const VehicleDetailsDialog({super.key});

  @override
  State<VehicleDetailsDialog> createState() => _VehicleDetailsDialogState();
}

class _VehicleDetailsDialogState extends State<VehicleDetailsDialog> {
  final _licensePlateController = TextEditingController();
  VehicleSize selectedSize = VehicleSize.small;
  VehicleType selectedType = VehicleType.regular;

  @override
  void dispose() {
    _licensePlateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter Vehicle Details'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _licensePlateController,
              decoration: const InputDecoration(labelText: 'License Plate'),
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<VehicleSize>(
              value: selectedSize,
              decoration: const InputDecoration(labelText: 'Vehicle Size'),
              items: VehicleSize.values.map((size) {
                return DropdownMenuItem(
                  value: size,
                  child: Text(size.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedSize = value!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<VehicleType>(
              value: selectedType,
              decoration: const InputDecoration(labelText: 'Vehicle Type'),
              items: VehicleType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedType = value!),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_licensePlateController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please enter a license plate number'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }
            Navigator.pop(
              context,
              Vehicle(
                licensePlate: _licensePlateController.text.toUpperCase(),
                size: selectedSize,
                type: selectedType,
              ),
            );
          },
          child: const Text('Park'),
        ),
      ],
    );
  }
}
