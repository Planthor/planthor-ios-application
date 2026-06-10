import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planthor_ios_application/core/network/api_client.dart';
import 'package:planthor_ios_application/features/my_garden/domain/entities/personal_plan.dart';

final personalPlansProvider = FutureProvider<List<PersonalPlan>>((ref) async {
  final dio = ref.watch(apiClientProvider);
  final response = await dio.get('/v1/members/me/PersonalPlans');
  return (response.data as List)
      .map((e) => PersonalPlan.fromJson(e as Map<String, dynamic>))
      .toList();
});
