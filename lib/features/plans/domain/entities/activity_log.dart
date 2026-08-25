class ActivityLog {
  const ActivityLog({
    required this.id,
    required this.planId,
    required this.value,
    required this.activityLocalDate,
    required this.completedDate,
    this.externalSourceProvider,
    this.externalSourceId,
  });

  factory ActivityLog.fromJson(Map<String, dynamic> json) => ActivityLog(
    id: json['id'] as String? ?? '',
    planId: json['planId'] as String? ?? '',
    value: (json['value'] as num?)?.toDouble() ?? 0,
    activityLocalDate: json['activityLocalDate'] as String? ?? '',
    completedDate: json['completedDate'] != null
        ? DateTime.parse(json['completedDate'] as String)
        : DateTime.now(),
    externalSourceProvider: json['externalSourceProvider'] as String?,
    externalSourceId: json['externalSourceId'] as String?,
  );

  final String id;
  final String planId;
  final double value;
  final String activityLocalDate;
  final DateTime completedDate;
  final String? externalSourceProvider;
  final String? externalSourceId;
}
