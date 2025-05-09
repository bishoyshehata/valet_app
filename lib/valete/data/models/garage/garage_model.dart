class ParkingSlot {
  final int id;
  final String name;
  final String image;
  final bool isOccupied;
  final bool isSelected;

  ParkingSlot({
    required this.id,
    required this.name,
    this.isOccupied = false,
    this.image = '',
    this.isSelected = false,
  });
}
