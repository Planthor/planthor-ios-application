import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planthor_ios_application/core/network/api_client.dart';
import 'package:planthor_ios_application/features/plans/domain/entities/personal_plan.dart';

final personalPlansProvider = FutureProvider<List<PersonalPlan>>((ref) async {
  final dio = ref.watch(apiClientProvider);
  final response = await dio.get('/v1/members/me/personal-plans');
  return parsePersonalPlansResponse(response.data);
});

List<PersonalPlan> parsePersonalPlansResponse(Object? data) {
  final items = switch (data) {
    {'items': final List<dynamic> items} => items,
    final List<dynamic> items => items,
    _ => throw const FormatException('Invalid personal plans response'),
  };

  return items
      .map((e) => PersonalPlan.fromJson(e as Map<String, dynamic>))
      .toList();
}
