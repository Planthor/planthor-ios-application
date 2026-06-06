import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planthor_ios_application/core/config/app_config.dart';
import 'package:planthor_ios_application/features/auth/presentation/providers/auth_provider.dart';

final apiClientProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(baseUrl: AppConfig.apiBase));

  // Inject token at request time so late-resolving auth state is always current.
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = ref.read(authProvider).valueOrNull?.accessToken;
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    ),
  );

  // Log every request/response to help diagnose auth issues.
  dio.interceptors.add(
    LogInterceptor(requestBody: false, responseBody: true, logPrint: (o) {
      // ignore: avoid_print
      print('[API] $o');
    }),
  );

  return dio;
});
