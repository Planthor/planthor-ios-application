class SportType {
  const SportType({
    required this.id,
    required this.name,
  });

  factory SportType.fromJson(Map<String, dynamic> json) {
    return SportType(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  final String id;
  final String name;
}
