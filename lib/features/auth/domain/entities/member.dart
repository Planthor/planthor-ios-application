class Member {

  const Member({
    required this.id,
    required this.firstName,
    this.middleName,
    required this.lastName,
    this.description,
    required this.pathAvatar,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
    id: json['id'] as String,
    firstName: json['firstName'] as String,
    middleName: json['middleName'] as String?,
    lastName: json['lastName'] as String,
    description: json['description'] as String?,
    pathAvatar: json['pathAvatar'] as String? ?? '',
  );
  final String id;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String? description;
  final String pathAvatar;

  String get displayName {
    final parts = [
      firstName,
      if (middleName != null && middleName!.isNotEmpty) middleName!,
      lastName,
    ];
    return parts.join(' ').trim();
  }
}
