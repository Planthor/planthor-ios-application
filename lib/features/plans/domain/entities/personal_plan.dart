import 'package:flutter/material.dart';

/// Status of a personal plan.
enum PlanStatus {
  active,
  completed,
  overdue,
  upcoming;

  String get label {
    return switch (this) {
      PlanStatus.active => 'Active',
      PlanStatus.completed => 'Completed',
      PlanStatus.overdue => 'Overdue',
      PlanStatus.upcoming => 'Upcoming',
    };
  }
}

class PersonalPlan {
  final String id;
  final String name;
  final String dateRange;
  final double current;
  final double target;
  final String unit;
  final IconData icon;
  final PlanStatus status;
  final String? description;

  const PersonalPlan({
    required this.id,
    required this.name,
    this.dateRange = '',
    this.current = 0,
    this.target = 0,
    this.unit = '',
    this.icon = Icons.fitness_center,
    this.status = PlanStatus.active,
    this.description,
  });

  double get progress => target > 0 ? (current / target).clamp(0.0, 1.0) : 0;
  double get progressRaw => target > 0 ? current / target : 0;
  int get progressPercent => (progressRaw * 100).round();
  bool get isComplete => progressRaw >= 1.0;

  factory PersonalPlan.fromJson(Map<String, dynamic> json) => PersonalPlan(
        id: json['planId'] as String,
        name: json['planName'] as String? ?? '(unnamed)',
        unit: json['unit'] as String? ?? '',
        target: (json['target'] as num?)?.toDouble() ?? 0,
        current: (json['currentValue'] as num?)?.toDouble() ?? 0,
        status: _parseStatus(json['status'] as String? ?? ''),
        dateRange: _formatDateRange(
          json['fromDate'] as String?,
          json['toDate'] as String?,
        ),
      );

  static PlanStatus _parseStatus(String status) => switch (status.toLowerCase()) {
        'completed' => PlanStatus.completed,
        'overdue' => PlanStatus.overdue,
        'upcoming' => PlanStatus.upcoming,
        _ => PlanStatus.active,
      };

  static String _formatDateRange(String? from, String? to) {
    if (from == null || to == null) return '';
    final f = DateTime.tryParse(from);
    final t = DateTime.tryParse(to);
    if (f == null || t == null) return '';
    String fmt(DateTime d) =>
        '${_month(d.month)} ${d.day}, ${d.year}';
    return '${fmt(f)} – ${fmt(t)}';
  }

  static String _month(int m) => const [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ][m];
}
