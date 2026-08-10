import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planthor_ios_application/core/network/api_client.dart';
import 'package:planthor_ios_application/features/plans/domain/entities/sport_type.dart';

final sportTypesProvider = FutureProvider<List<SportType>>((ref) async {
  final dio = ref.watch(apiClientProvider);
  final response = await dio.get('/v1/sport-types');
  final data = response.data as List;
  return data.map((e) => SportType.fromJson(e as Map<String, dynamic>)).toList();
});
