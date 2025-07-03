// Presentation Layer: Parking Lot UI

import 'package:flutter/material.dart';

import '../../domain/entities/parking_entities.dart';
import '../../injection/parking_injection.dart';
import '../controllers/parking_controller.dart';

class ParkingLotScreen extends StatefulWidget {
  const ParkingLotScreen({super.key});

  @override
  State<ParkingLotScreen> createState() => _ParkingLotScreenState();
}

class _ParkingLotScreenState extends State<ParkingLotScreen> {
  late ParkingController controller;
  List<ParkingSlot> slots = [];
  List<ParkingTicket> activeTickets = [];

  @override
  void initState() {
    super.initState();
    controller = ParkingDependencyInjection.getParkingController();
    _setupListeners();
  }

  void _setupListeners() {
    controller.slotsStream.listen((newSlots) {
      setState(() => slots = newSlots);
    });

    controller.ticketsStream.listen((tickets) {
      setState(() => activeTickets = tickets);
    });

    controller.errorStream.listen((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    });

    controller.messageStream.listen((message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking Lot Management'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => controller.setPricingType(value),
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
                  Text(controller.selectedPricingType.toUpperCase()),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSummaryCard(),
          const SizedBox(height: 16),
          Expanded(child: _buildSlotsGrid()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showActiveTicketsDialog(),
        backgroundColor: Colors.blue.shade800,
        child: const Icon(Icons.receipt, color: Colors.white),
      ),
    );
  }

  Widget _buildSummaryCard() {
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
          _buildSummaryItem('Total', '${slots.length}', Colors.blue),
          _buildSummaryItem('Available', '$availableSlots', Colors.green),
          _buildSummaryItem('Occupied', '$occupiedSlots', Colors.orange),
          _buildSummaryItem(
              'Traffic',
              '${(trafficLevel * 100).toInt()}%',
              trafficLevel > 0.8
                  ? Colors.red
                  : trafficLevel > 0.6
                      ? Colors.orange
                      : Colors.green),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        Text(label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildSlotsGrid() {
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
        return _buildSlotCard(slot);
      },
    );
  }

  Widget _buildSlotCard(ParkingSlot slot) {
    Color cardColor;
    IconData icon;
    VoidCallback? onTap;

    if (slot.isOccupied) {
      cardColor = Colors.red.shade100;
      icon = Icons.car_rental;
      onTap = () => _showUnparkDialog(slot);
    } else {
      cardColor = slot.isVip ? Colors.purple.shade100 : Colors.green.shade100;
      icon = slot.isVip ? Icons.star : Icons.local_parking;
      onTap = () => _parkVehicle(slot.id);
    }

    return GestureDetector(
      onTap: onTap,
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
            Icon(icon,
                size: 20,
                color: slot.isOccupied
                    ? Colors.red
                    : slot.isVip
                        ? Colors.purple
                        : Colors.green),
            const SizedBox(height: 4),
            Text('${slot.id}',
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            if (slot.isVip)
              const Text('VIP',
                  style: TextStyle(fontSize: 8, color: Colors.purple)),
          ],
        ),
      ),
    );
  }

  void _parkVehicle(int slotId) {
    controller.parkVehicle(slotId);
  }

  void _showUnparkDialog(ParkingSlot slot) {
    final ticket = activeTickets.firstWhere(
      (ticket) => ticket.slotId == slot.id,
      orElse: () => ParkingTicket(slotId: slot.id, entryTime: DateTime.now()),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Unpark Vehicle - Slot ${slot.id}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Entry Time: ${ticket.entryTime.toString().substring(0, 16)}'),
            Text(
                'Duration: ${DateTime.now().difference(ticket.entryTime).inHours}h ${DateTime.now().difference(ticket.entryTime).inMinutes % 60}m'),
            Text('Pricing: ${controller.selectedPricingType.toUpperCase()}'),
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
              controller.unparkVehicle(ticket);
            },
            child: const Text('Unpark'),
          ),
        ],
      ),
    );
  }

  void _showActiveTicketsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Active Tickets'),
        content: SizedBox(
          width: 300,
          height: 400,
          child: activeTickets.isEmpty
              ? const Center(child: Text('No active tickets'))
              : ListView.builder(
                  itemCount: activeTickets.length,
                  itemBuilder: (context, index) {
                    final ticket = activeTickets[index];
                    final duration =
                        DateTime.now().difference(ticket.entryTime);
                    return Card(
                      child: ListTile(
                        title: Text('Slot ${ticket.slotId}'),
                        subtitle: Text(
                            'Entry: ${ticket.entryTime.toString().substring(0, 16)}'),
                        trailing: Text(
                            '${duration.inHours}h ${duration.inMinutes % 60}m'),
                      ),
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
      ),
    );
  }

  @override
  void dispose() {
    // Note: Don't dispose the controller here as it's managed by injection
    super.dispose();
  }
}
