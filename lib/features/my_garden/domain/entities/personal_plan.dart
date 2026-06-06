class PersonalPlan {
  final String id;
  final String name;

  const PersonalPlan({required this.id, required this.name});

  factory PersonalPlan.fromJson(Map<String, dynamic> json) => PersonalPlan(
        id: json['id'] as String,
        name: json['name'] as String? ?? '(unnamed)',
      );
}
