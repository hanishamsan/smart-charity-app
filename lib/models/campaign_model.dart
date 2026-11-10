class Campaign {
  final String id;
  final String title;
  final String description;
  final double targetAmount;
  final double currentAmount;

  Campaign({
    required this.id,
    required this.title,
    required this.description,
    required this.targetAmount,
    required this.currentAmount,
  });

  factory Campaign.fromFirestore(String id, Map<String, dynamic> data) {
    return Campaign(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      targetAmount: (data['targetAmount'] ?? 0).toDouble(),
      currentAmount: (data['currentAmount'] ?? 0).toDouble(),
    );
  }
}
