class Garage {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final int totalSpots;
  final int availableSpots;

  Garage({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.totalSpots,
    required this.availableSpots,
  });
}
