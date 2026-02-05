class Club {
  const Club({required this.id, required this.name, required this.description, required this.logoUrl});

  final String id;
  final String name;
  final String description;
  final String logoUrl;

  factory Club.fromMap(String id, Map<String, dynamic> data) => Club(
        id: id,
        name: data['name'] ?? '',
        description: data['description'] ?? '',
        logoUrl: data['logoUrl'] ?? '',
      );
}
