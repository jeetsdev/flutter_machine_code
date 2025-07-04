import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/parking_entities.dart';
import '../bloc/parking_bloc.dart';
import '../bloc/parking_event.dart';
import '../bloc/parking_state.dart';

class SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const SummaryItem({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

class SummaryCard extends StatelessWidget {
  final ParkingState state;

  const SummaryCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SummaryItem(
            label: 'Total',
            value: '${state.slots.length}',
            color: Colors.blue,
          ),
          SummaryItem(
            label: 'Available',
            value:
                '${state.slots.length - state.slots.where((slot) => slot.isOccupied).length}',
            color: Colors.green,
          ),
          SummaryItem(
            label: 'Occupied',
            value: '${state.slots.where((slot) => slot.isOccupied).length}',
            color: Colors.orange,
          ),
          SummaryItem(
            label: 'Traffic',
            value: '${(state.trafficLevel * 100).toInt()}%',
            color: state.trafficLevel > 0.8
                ? Colors.red
                : state.trafficLevel > 0.6
                    ? Colors.orange
                    : Colors.green,
          ),
        ],
      ),
    );
  }
}

class ParkingGrid extends StatelessWidget {
  final List<ParkingSlot> slots;
  final Function(BuildContext, ParkingSlot, ParkingBloc) onUnpark;

  const ParkingGrid({
    super.key,
    required this.slots,
    required this.onUnpark,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];
        return SlotCard(
          slot: slot,
          onUnpark: onUnpark,
        );
      },
    );
  }
}

class SlotCard extends StatelessWidget {
  final ParkingSlot slot;
  final Function(BuildContext, ParkingSlot, ParkingBloc) onUnpark;

  const SlotCard({
    super.key,
    required this.slot,
    required this.onUnpark,
  });

  @override
  Widget build(BuildContext context) {
    Color cardColor;
    IconData icon;

    if (slot.isOccupied) {
      cardColor = Colors.red.shade100;
      icon = Icons.car_rental;
    } else {
      cardColor = slot.isVip ? Colors.purple.shade100 : Colors.green.shade100;
      icon = slot.isVip ? Icons.star : Icons.local_parking;
    }

    return GestureDetector(
      onTap: () {
        if (slot.isOccupied) {
          onUnpark(context, slot, context.read<ParkingBloc>());
        } else {
          context.read<ParkingBloc>().add(ParkVehicle(slot.id));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: slot.isVip ? Colors.purple : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: slot.isOccupied
                  ? Colors.red
                  : slot.isVip
                      ? Colors.purple
                      : Colors.green,
            ),
            const SizedBox(height: 4),
            Text(
              '#${slot.id}',
              style: TextStyle(
                color: slot.isOccupied ? Colors.red : Colors.grey.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ParkingLotScreen extends StatefulWidget {
  const ParkingLotScreen({super.key});

  @override
  State<ParkingLotScreen> createState() => _ParkingLotScreenState();
}

class _ParkingLotScreenState extends State<ParkingLotScreen> {
  late ParkingBloc _parkingBloc;
  void _showPricingDialog(BuildContext context, ParkingBloc bloc) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Pricing Type'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              bloc.add(SelectPricingType('hourly'));
              Navigator.pop(context);
            },
            child: const Text('HOURLY'),
          ),
          SimpleDialogOption(
            onPressed: () {
              bloc.add(SelectPricingType('daily'));
              Navigator.pop(context);
            },
            child: const Text('DAILY'),
          ),
          SimpleDialogOption(
            onPressed: () {
              bloc.add(SelectPricingType('vip'));
              Navigator.pop(context);
            },
            child: const Text('VIP'),
          ),
        ],
      ),
    );
  }

  void _showUnparkDialog(
      BuildContext context, ParkingSlot slot, ParkingBloc bloc) {
    final ticket = ParkingTicket(
      slotId: slot.id,
      entryTime: DateTime.now().subtract(const Duration(hours: 2)),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unpark Vehicle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Slot: #${slot.id}'),
            const SizedBox(height: 8),
            const Text('Calculate fee based on time...'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              bloc.add(
                UnparkVehicle(ticket, bloc.state.selectedPricingType),
              );
              Navigator.pop(context);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showActiveTicketsDialog(BuildContext context, ParkingState state) {
    showDialog(
      context: context,
      builder: (context) => ActiveTicketsDialog(
        slots: state.slots.where((slot) => slot.isOccupied).toList(),
        onUnpark: (slot) {
          Navigator.pop(context);
          _showUnparkDialog(context, slot, _parkingBloc);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _parkingBloc = context.read<ParkingBloc>();
      _parkingBloc.add(LoadParkingSlots());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ParkingBloc, ParkingState>(
      listener: (context, state) {
        // if (state.isSuccess) {
        //   if (state.lastParkedTicket != null) {
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       SnackBar(
        //         content: Text(
        //             'Vehicle parked in slot #${state.lastParkedTicket!.slotId}'),
        //         backgroundColor: Colors.green,
        //       ),
        //     );
        //   }
        //   if (state.lastUnparkResult != null) {
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       SnackBar(
        //         content: Text(
        //             'Vehicle unparked. Fee: \$${state.lastUnparkResult!.price.toStringAsFixed(2)} (${state.lastUnparkResult!.pricingStrategy})'),
        //         backgroundColor: Colors.blue,
        //       ),
        //     );
        //   }
        // }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: state.isInitial || state.isLoading
              ? null
              : AppBar(
                  title: const Text('Parking Lot Management'),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  actions: [
                    TextButton.icon(
                      onPressed: () =>
                          _showPricingDialog(context, _parkingBloc),
                      icon: Text(
                        state.selectedPricingType.toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                      label: const Icon(Icons.arrow_drop_down,
                          color: Colors.white),
                    ),
                  ],
                ),
          body: Builder(
            builder: (context) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.isError) {
                return Center(child: Text(state.errorMessage!));
              }

              if (state.isSuccess) {
                return Column(
                  children: [
                    SummaryCard(state: state),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ParkingGrid(
                        slots: state.slots,
                        onUnpark: _showUnparkDialog,
                      ),
                    ),
                  ],
                );
              }

              return const Center(child: Text('No parking slots available'));
            },
          ),
          floatingActionButton: state.isSuccess
              ? FloatingActionButton(
                  onPressed: () => _showActiveTicketsDialog(context, state),
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.receipt, color: Colors.white),
                )
              : null,
        );
      },
    );
  }
}

class ActiveTicketsDialog extends StatelessWidget {
  final List<ParkingSlot> slots;
  final Function(ParkingSlot) onUnpark;

  const ActiveTicketsDialog({
    super.key,
    required this.slots,
    required this.onUnpark,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Active Tickets'),
      content: SizedBox(
        width: double.maxFinite,
        child: slots.isEmpty
            ? const Center(child: Text('No active tickets'))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: slots.length,
                itemBuilder: (context, index) {
                  final slot = slots[index];
                  return ListTile(
                    title: Text('Slot #${slot.id}'),
                    subtitle: const Text('Occupied'),
                    onTap: () => onUnpark(slot),
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
