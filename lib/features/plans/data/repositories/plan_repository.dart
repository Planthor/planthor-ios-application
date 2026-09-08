import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planthor_ios_application/core/network/api_client.dart';

final planRepositoryProvider = Provider<PlanRepository>((ref) {
  return PlanRepository(ref.watch(apiClientProvider));
});

class PlanRepository {
  PlanRepository(this._dio);
  final Dio _dio;

  Future<void> createPlan(Map<String, dynamic> data) async {
    await _dio.post('/v1/members/me/personal-plans', data: data);
  }

  Future<void> updatePlan(String planId, Map<String, dynamic> data) async {
    await _dio.put('/v1/members/me/personal-plans/$planId', data: data);
  }

  Future<void> deletePlan(String planId) async {
    await _dio.delete('/v1/members/me/personal-plans/$planId');
  }
}
