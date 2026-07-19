enum RewardType {
  marketplace,
  event,
}

class RewardModel {
  final String title;
  final String description;
  final String expiryDate;
  final String points;
  final String imageUrl;
  final String brandLogoUrl;
  final RewardType type;

  const RewardModel({
    required this.title,
    required this.description,
    required this.expiryDate,
    required this.points,
    required this.imageUrl,
    required this.brandLogoUrl,
    this.type = RewardType.marketplace,
  });
}
