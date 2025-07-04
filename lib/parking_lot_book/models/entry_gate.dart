import 'package:equatable/equatable.dart';

class EntryGate extends Equatable {
  final String id;
  final String name;
  final int floor;
  final double xPosition;
  final double yPosition;
  final bool isActive;

  const EntryGate({
    required this.id,
    required this.name,
    required this.floor,
    required this.xPosition,
    required this.yPosition,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [id, name, floor, xPosition, yPosition, isActive];

  double distanceTo(double x, double y) {
    return ((xPosition - x) * (xPosition - x) +
        (yPosition - y) * (yPosition - y));
  }

  EntryGate copyWith({
    String? id,
    String? name,
    int? floor,
    double? xPosition,
    double? yPosition,
    bool? isActive,
  }) {
    return EntryGate(
      id: id ?? this.id,
      name: name ?? this.name,
      floor: floor ?? this.floor,
      xPosition: xPosition ?? this.xPosition,
      yPosition: yPosition ?? this.yPosition,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'EntryGate(id: $id, name: $name, floor: $floor, position: ($xPosition, $yPosition))';
  }
}
