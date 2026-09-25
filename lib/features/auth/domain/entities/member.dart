class Member {
  const Member({
    required this.id,
    required this.firstName,
    this.middleName,
    required this.lastName,
    this.description,
    required this.pathAvatar,
    required this.autoLinkPlansAndActivityApplications,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
    id: json['id'] as String,
    firstName: json['firstName'] as String,
    middleName: json['middleName'] as String?,
    lastName: json['lastName'] as String,
    description: json['description'] as String?,
    pathAvatar: json['pathAvatar'] as String? ?? '',
    autoLinkPlansAndActivityApplications:
        json['autoLinkUserAdapterToPlan'] as bool,
  );
  final String id;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String? description;
  final String pathAvatar;
  final bool autoLinkPlansAndActivityApplications;

  Member copyWith({
    String? id,
    String? firstName,
    String? middleName,
    String? lastName,
    String? description,
    String? pathAvatar,
    bool? autoLinkPlansAndActivityApplications,
  }) {
    return Member(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      description: description ?? this.description,
      pathAvatar: pathAvatar ?? this.pathAvatar,
      autoLinkPlansAndActivityApplications:
          autoLinkPlansAndActivityApplications ??
          this.autoLinkPlansAndActivityApplications,
    );
  }

  String get displayName {
    final parts = [
      firstName,
      if (middleName != null && middleName!.isNotEmpty) middleName!,
      lastName,
    ];
    return parts.join(' ').trim();
  }
}
