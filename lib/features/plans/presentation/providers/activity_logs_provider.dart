import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planthor_ios_application/core/network/api_client.dart';
import 'package:planthor_ios_application/features/plans/domain/entities/activity_log.dart';

final activityLogsProvider = FutureProvider.family<List<ActivityLog>, String>((
  ref,
  planId,
) async {
  final dio = ref.watch(apiClientProvider);
  final response = await dio.get('/v1/plans/$planId/activity-logs');
  return parseActivityLogsResponse(response.data);
});

List<ActivityLog> parseActivityLogsResponse(Object? data) {
  final items = switch (data) {
    {'items': final List<dynamic> items} => items,
    final List<dynamic> items => items,
    _ => throw const FormatException('Invalid activity logs response'),
  };

  return items
      .map((e) => ActivityLog.fromJson(e as Map<String, dynamic>))
      .toList();
}
