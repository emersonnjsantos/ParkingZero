class Garage {
  final String id;
  final String name;
  final double basePrice;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final List<Campaign> campaigns;

  Garage({
    required this.id,
    required this.name,
    required this.basePrice,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    this.campaigns = const [],
  });
}

class Campaign {
  final String partnerName;
  final String discountRule;

  Campaign({
    required this.partnerName,
    required this.discountRule,
  });
}
