import 'parking_slot.dart';

class EntryGate {
  final String id;
  final String name;
  final List<ParkingSlot> nearbySlots;

  const EntryGate({
    required this.id,
    required this.name,
    required this.nearbySlots,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntryGate && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'EntryGate(id: $id, name: $name, slots: ${nearbySlots.length})';
}
