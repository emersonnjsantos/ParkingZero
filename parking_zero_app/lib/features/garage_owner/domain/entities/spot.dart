class Spot {
  final int number;
  bool isOccupied;
  String? reservationId;

  Spot({
    required this.number,
    this.isOccupied = false,
    this.reservationId,
  });
}
