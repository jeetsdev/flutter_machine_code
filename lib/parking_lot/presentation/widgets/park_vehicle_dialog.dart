import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/vehicle_size.dart';
import '../bloc/parking_lot_bloc.dart';

class ParkVehicleDialog extends StatefulWidget {
  const ParkVehicleDialog({super.key});

  @override
  State<ParkVehicleDialog> createState() => _ParkVehicleDialogState();
}

class _ParkVehicleDialogState extends State<ParkVehicleDialog> {
  final _formKey = GlobalKey<FormState>();
  final _licensePlateController = TextEditingController();
  VehicleSize? _selectedSize;
  String? _selectedGateId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParkingLotBloc, ParkingLotState>(
      builder: (context, state) {
        if (state is! ParkingLotLoaded) {
          return const AlertDialog(
            title: Text('Error'),
            content: Text('Unable to park vehicle at this time'),
          );
        }

        return AlertDialog(
          title: const Text('Park a Vehicle'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _licensePlateController,
                  decoration: const InputDecoration(
                    labelText: 'License Plate',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a license plate number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<VehicleSize>(
                  value: _selectedSize,
                  decoration: const InputDecoration(
                    labelText: 'Vehicle Size',
                  ),
                  items: VehicleSize.values.map((size) {
                    return DropdownMenuItem(
                      value: size,
                      child: Text(size.name.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSize = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a vehicle size';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedGateId,
                  decoration: const InputDecoration(
                    labelText: 'Entry Gate',
                  ),
                  items: state.parkingLot.entryGates.map((gate) {
                    return DropdownMenuItem(
                      value: gate.id,
                      child: Text(gate.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGateId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select an entry gate';
                    }
                    return null;
                  },
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
                if (_formKey.currentState?.validate() ?? false) {
                  context.read<ParkingLotBloc>().add(ParkNewVehicle(
                        licensePlate: _licensePlateController.text,
                        vehicleSize: _selectedSize!,
                        entryGateId: _selectedGateId!,
                      ));
                  Navigator.pop(context);
                }
              },
              child: const Text('Park'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _licensePlateController.dispose();
    super.dispose();
  }
}
