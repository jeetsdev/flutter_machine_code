// Presentation Layer: Parking Lot UI

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/vehicle_entities.dart';
import '../../injection/parking_injection.dart';
import '../bloc/parking_bloc.dart';
import '../bloc/parking_event.dart';
import '../bloc/parking_state.dart';
import '../widgets/vehicle_details_dialog.dart';

class ParkingLotScreen extends StatelessWidget {
  const ParkingLotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ParkingDependencyInjection.getParkingBloc()..add(LoadParkingSlots()),
      child: const _ParkingLotView(),
    );
  }
}

class _ParkingLotView extends StatelessWidget {
  const _ParkingLotView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ParkingBloc, ParkingState>(
      listener: (context, state) {
        // Handle messages
        if (state.message != null) {
          final isError = state is ParkingError;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message!),
              backgroundColor: isError ? Colors.red : Colors.green,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ParkingLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is! ParkingLoaded) {
          return const Scaffold(
            body: Center(child: Text('Something went wrong')),
          );
        }

        return _ParkingLotContent(state: state);
      },
    );
  }
}

class _ParkingLotContent extends StatelessWidget {
  final ParkingLoaded state;

  const _ParkingLotContent({required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking Lot Management'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        actions: [
          _PricingTypeMenu(selectedType: state.selectedPricingType),
          IconButton(
            icon: const Icon(Icons.receipt_long),
            onPressed: () => showDialog(
              context: context,
              builder: (context) =>
                  ActiveTicketsDialog(tickets: state.activeTickets),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          ParkingSummaryCard(slots: state.slots),
          const SizedBox(height: 16),
          Expanded(child: ParkingSlotsGrid(slots: state.slots)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) =>
              ActiveTicketsDialog(tickets: state.activeTickets),
        ),
        backgroundColor: Colors.blue.shade800,
        child: const Icon(Icons.receipt, color: Colors.white),
      ),
    );
  }
}

class _PricingTypeMenu extends StatelessWidget {
  final String selectedType;

  const _PricingTypeMenu({required this.selectedType});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) =>
          context.read<ParkingBloc>().add(SelectPricingType(value)),
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'hourly', child: Text('Hourly')),
        const PopupMenuItem(value: 'daily', child: Text('Daily')),
        const PopupMenuItem(value: 'vip', child: Text('VIP')),
      ],
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(selectedType.toUpperCase()),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}

class ParkingSummaryCard extends StatelessWidget {
  final List<ParkingSlot> slots;

  const ParkingSummaryCard({super.key, required this.slots});

  @override
  Widget build(BuildContext context) {
    final occupiedSlots = slots.where((slot) => slot.isOccupied).length;
    final availableSlots = slots.length - occupiedSlots;
    final trafficLevel = slots.isNotEmpty ? occupiedSlots / slots.length : 0.0;

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
              label: 'Total', value: '${slots.length}', color: Colors.blue),
          SummaryItem(
              label: 'Available',
              value: '$availableSlots',
              color: Colors.green),
          SummaryItem(
              label: 'Occupied', value: '$occupiedSlots', color: Colors.orange),
          SummaryItem(
            label: 'Traffic',
            value: '${(trafficLevel * 100).toInt()}%',
            color: trafficLevel > 0.8
                ? Colors.red
                : trafficLevel > 0.6
                    ? Colors.orange
                    : Colors.green,
          ),
        ],
      ),
    );
  }
}

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
              fontSize: 24, fontWeight: FontWeight.bold, color: color),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

class ParkingSlotsGrid extends StatelessWidget {
  final List<ParkingSlot> slots;

  const ParkingSlotsGrid({super.key, required this.slots});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) => ParkingSlotCard(slot: slots[index]),
    );
  }
}

class ParkingSlotCard extends StatelessWidget {
  final ParkingSlot slot;

  const ParkingSlotCard({super.key, required this.slot});

  @override
  Widget build(BuildContext context) {
    final (baseColor, borderColor, icon) = _getSlotStyle();

    return GestureDetector(
      onTap: () => _handleTap(context),
      child: Container(
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: borderColor),
            const SizedBox(height: 4),
            Text(
              'Slot ID : ${slot.id}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            Text(
              slot.isOccupied
                  ? slot.occupiedBy ?? 'Occupied'
                  : 'SLOT SIZE ${slot.size.name.toUpperCase()}\n SLOT TYPE: ${slot.type.name.toUpperCase()}',
              style: const TextStyle(fontSize: 8, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  (Color, Color, IconData) _getSlotStyle() {
    if (slot.isOccupied) {
      return (
        Colors.red.shade50,
        Colors.red,
        Icons.car_rental,
      );
    }

    switch (slot.type) {
      case SlotType.vip:
        return (
          Colors.purple.shade50,
          Colors.purple,
          Icons.star,
        );
      case SlotType.handicapped:
        return (
          Colors.indigo.shade50,
          Colors.indigo,
          Icons.accessible,
        );
      default:
        switch (slot.size) {
          case SlotSize.small:
            return (
              Colors.green.shade50,
              Colors.green.shade300,
              Icons.directions_car,
            );
          case SlotSize.medium:
            return (
              Colors.blue.shade50,
              Colors.blue.shade300,
              Icons.directions_car,
            );
          case SlotSize.large:
            return (
              Colors.orange.shade50,
              Colors.orange.shade300,
              Icons.airport_shuttle,
            );
        }
    }
  }

  void _handleTap(BuildContext context) {
    if (slot.isOccupied) {
      _showUnparkDialog(context);
    } else {
      _showVehicleDetailsDialog(context);
    }
  }

  void _showUnparkDialog(BuildContext context) {
    final bloc = context.read<ParkingBloc>();
    final ticket = bloc.state is ParkingLoaded
        ? (bloc.state as ParkingLoaded).activeTickets.firstWhere(
              (ticket) => ticket.slotId == slot.id,
              orElse: () => ParkingTicket(
                id: 'TKT-${DateTime.now().millisecondsSinceEpoch}',
                licensePlate: slot.occupiedBy ?? 'UNKNOWN',
                slotId: slot.id,
                entryTime: DateTime.now(),
                vehicleSize: VehicleSize.small,
                vehicleType: VehicleType.regular,
              ),
            )
        : null;

    if (ticket == null) return;

    showDialog(
      context: context,
      builder: (context) => UnparkDialog(ticket: ticket, parkingBloc: bloc),
    );
  }

  Future<void> _showVehicleDetailsDialog(BuildContext context) async {
    final vehicle = await showDialog<Vehicle>(
      context: context,
      builder: (context) => const VehicleDetailsDialog(),
    );

    if (vehicle == null) return;

    if (!vehicle.canFitInSlot(slot)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vehicle cannot be parked in this slot type/size'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!context.mounted) return;

    try {
      context.read<ParkingBloc>().add(ParkVehicle(slot.id, vehicle));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to park: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class ActiveTicketsDialog extends StatelessWidget {
  final List<ParkingTicket> tickets;

  const ActiveTicketsDialog({super.key, required this.tickets});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Active Tickets'),
      content: SizedBox(
        width: 300,
        height: 400,
        child: tickets.isEmpty
            ? const Center(child: Text('No active tickets'))
            : ListView.builder(
                itemCount: tickets.length,
                itemBuilder: (context, index) =>
                    TicketCard(ticket: tickets[index]),
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

class TicketCard extends StatelessWidget {
  final ParkingTicket ticket;

  const TicketCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final duration = DateTime.now().difference(ticket.entryTime);

    return Card(
      child: ListTile(
        title: Text('Slot ${ticket.slotId} - ${ticket.licensePlate}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Entry: ${ticket.entryTime.toString().substring(0, 16)}'),
            Text(
                'Type: ${ticket.vehicleType.name.toUpperCase()} - ${ticket.vehicleSize.name.toUpperCase()}'),
          ],
        ),
        trailing: Text('${duration.inHours}h ${duration.inMinutes % 60}m'),
      ),
    );
  }
}

class UnparkDialog extends StatelessWidget {
  final ParkingTicket ticket;
  final ParkingBloc parkingBloc;

  const UnparkDialog(
      {super.key, required this.ticket, required this.parkingBloc});

  @override
  Widget build(BuildContext context) {
    final pricingType = parkingBloc.state is ParkingLoaded
        ? (parkingBloc.state as ParkingLoaded).selectedPricingType
        : 'hourly';
    final duration = DateTime.now().difference(ticket.entryTime);

    return AlertDialog(
      title: Text('Unpark Vehicle - Slot ${ticket.slotId}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Entry Time: ${ticket.entryTime.toString().substring(0, 16)}'),
          Text('Duration: ${duration.inHours}h ${duration.inMinutes % 60}m'),
          Text('Pricing: ${pricingType.toUpperCase()}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            parkingBloc.add(UnparkVehicle(ticket, pricingType));
          },
          child: const Text('Unpark'),
        ),
      ],
    );
  }
}
