class CampusEvent {
  const CampusEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.clubId,
    required this.city,
    required this.date,
    required this.latitude,
    required this.longitude,
  });

  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String clubId;
  final String city;
  final DateTime date;
  final double latitude;
  final double longitude;

  factory CampusEvent.fromMap(String id, Map<String, dynamic> data) => CampusEvent(
        id: id,
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        imageUrl: data['imageUrl'] ?? '',
        clubId: data['clubId'] ?? '',
        city: data['city'] ?? 'Casablanca',
        date: DateTime.tryParse(data['date'] ?? '') ?? DateTime.now(),
        latitude: (data['latitude'] ?? 33.5731).toDouble(),
        longitude: (data['longitude'] ?? -7.5898).toDouble(),
      );
}
