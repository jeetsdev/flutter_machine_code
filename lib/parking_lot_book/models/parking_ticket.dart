import 'package:equatable/equatable.dart';
import 'package:test_app/parking_lot/parking_lot.dart';
import 'parking_slot.dart';
import 'entry_gate.dart';

class ParkingTicket extends Equatable {
  final String ticketId;
  final Vehicle car;
  final ParkingSlot assignedSlot;
  final EntryGate entryGate;
  final DateTime entryTime;
  final DateTime? exitTime;
  final double? fee;

  const ParkingTicket({
    required this.ticketId,
    required this.car,
    required this.assignedSlot,
    required this.entryGate,
    required this.entryTime,
    this.exitTime,
    this.fee,
  });

  @override
  List<Object?> get props => [
        ticketId,
        car,
        assignedSlot,
        entryGate,
        entryTime,
        exitTime,
        fee,
      ];

  bool get isActive => exitTime == null;

  Duration get parkingDuration {
    final endTime = exitTime ?? DateTime.now();
    return endTime.difference(entryTime);
  }

  ParkingTicket copyWith({
    String? ticketId,
    Vehicle? car,
    ParkingSlot? assignedSlot,
    EntryGate? entryGate,
    DateTime? entryTime,
    DateTime? exitTime,
    double? fee,
  }) {
    return ParkingTicket(
      ticketId: ticketId ?? this.ticketId,
      car: car ?? this.car,
      assignedSlot: assignedSlot ?? this.assignedSlot,
      entryGate: entryGate ?? this.entryGate,
      entryTime: entryTime ?? this.entryTime,
      exitTime: exitTime ?? this.exitTime,
      fee: fee ?? this.fee,
    );
  }

  @override
  String toString() {
    return 'ParkingTicket(id: $ticketId, car: ${car.licensePlate}, slot: ${assignedSlot.id}, duration: ${parkingDuration.inMinutes} min)';
  }
}
