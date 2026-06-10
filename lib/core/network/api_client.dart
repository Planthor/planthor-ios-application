import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planthor_ios_application/core/config/app_config.dart';
import 'package:planthor_ios_application/features/auth/presentation/providers/auth_provider.dart';

final apiClientProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(baseUrl: AppConfig.apiBase));

  // Inject token at request time so late-resolving auth state is always current.
  // On 401: attempt silent token refresh and retry the request once.
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = ref.read(authProvider).valueOrNull?.accessToken;
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        final alreadyRetried = error.requestOptions.extra['_authRetried'] == true;
        if (error.response?.statusCode == 401 && !alreadyRetried) {
          final refreshed =
              await ref.read(authProvider.notifier).refreshTokens();
          if (refreshed != null) {
            final opts = error.requestOptions;
            opts.headers['Authorization'] = 'Bearer ${refreshed.accessToken}';
            opts.extra['_authRetried'] = true;
            try {
              final response = await dio.fetch(opts);
              return handler.resolve(response);
            } catch (retryError) {
              return handler.next(error);
            }
          }
        }
        handler.next(error);
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
