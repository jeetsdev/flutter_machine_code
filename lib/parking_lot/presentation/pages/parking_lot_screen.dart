import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/parking_lot_bloc.dart';
import '../widgets/entry_gates_section.dart';
import '../widgets/occupied_slots_section.dart';
import '../widgets/park_vehicle_dialog.dart';
import '../widgets/parking_status_card.dart';

class ParkingLotScreen extends StatelessWidget {
  const ParkingLotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ParkingLotBloc, ParkingLotState>(
      listener: (context, state) {
        if (state is VehicleParked) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is VehicleUnparked) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is ParkingLotError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Smart Parking System'),
          ),
          body: Builder(builder: (context) {
            if (state is ParkingLotInitial) {
              context.read<ParkingLotBloc>().add(LoadParkingLotStatus());
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ParkingLotLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ParkingLotLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ParkingStatusCard(state: state),
                    const SizedBox(height: 16),
                    EntryGatesSection(state: state),
                    const SizedBox(height: 16),
                    OccupiedSlotsSection(state: state),
                  ],
                ),
              );
            }

            if (state is ParkingLotError) {
              return Center(
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                ),
              );
            }

            return const Center(
              child: Text(
                'Unknown state',
                textAlign: TextAlign.center,
              ),
            );
          }),
          floatingActionButton: FloatingActionButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => const ParkVehicleDialog(),
            ),
            child: const Icon(Icons.car_rental),
          ),
        );
      },
    );
  }
}
