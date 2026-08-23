import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:planthor_ios_application/core/network/api_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'strava_connection_provider.g.dart';

/// Connection status for external app integrations.
enum StravaConnectionStatus { disconnected, connecting, connected }

/// Manages Strava connection state.
@riverpod
class StravaConnection extends _$StravaConnection {
  @override
  FutureOr<StravaConnectionStatus> build() async {
    return _fetchConnectionStatus();
  }

  Future<StravaConnectionStatus> _fetchConnectionStatus() async {
    try {
      final dio = ref.read(apiClientProvider);
      final response = await dio.get('/v1/members/me/external-connections');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final isConnected = data.any((c) =>
            c['providerId']?.toString().toLowerCase() == 'strava' &&
            c['statusId']?.toString() == 'A');
        return isConnected
            ? StravaConnectionStatus.connected
            : StravaConnectionStatus.disconnected;
      }
      return StravaConnectionStatus.disconnected;
    } catch (_) {
      return StravaConnectionStatus.disconnected;
    }
  }

  /// Initiates Strava OAuth connection via BFF flow.
  Future<void> connect() async {
    state = const AsyncValue.data(StravaConnectionStatus.connecting);
    try {
      final dio = ref.read(apiClientProvider);

      // Create a new dio instance that doesn't follow redirects
      // to capture the authorize URL from the backend.
      final dioNoRedirect = Dio(dio.options.copyWith(
        followRedirects: false,
        validateStatus: (status) => status != null && status < 400,
      ));
      dioNoRedirect.httpClientAdapter = dio.httpClientAdapter;
      dioNoRedirect.interceptors.addAll(dio.interceptors);

      final response = await dioNoRedirect.get('/v1/Strava/authorize');
      
      final authorizeUrl = response.headers.value('location');
      if (authorizeUrl == null) {
        throw Exception('No redirect location found');
      }

      // Launch secure web view and wait for planthor:// callback
      final resultUrl = await FlutterWebAuth2.authenticate(
        url: authorizeUrl,
        callbackUrlScheme: 'planthor',
      );

      if (resultUrl.contains('error=')) {
        throw Exception('Authorization failed or denied.');
      }

      // Re-fetch to confirm the backend successfully exchanged and saved
      final newStatus = await _fetchConnectionStatus();
      state = AsyncValue.data(newStatus);
    } catch (e, st) {
      log('CONNECT ERROR: $e\n$st', name: 'StravaConnection');
      state = const AsyncValue.data(StravaConnectionStatus.disconnected);
    }
  }

  /// Disconnects Strava integration.
  Future<void> disconnect() async {
    state = const AsyncValue.data(StravaConnectionStatus.connecting);
    try {
      final dio = ref.read(apiClientProvider);
      await dio.delete('/v1/Strava/disconnect');
      state = const AsyncValue.data(StravaConnectionStatus.disconnected);
    } catch (_) {
      state = const AsyncValue.data(StravaConnectionStatus.disconnected);
    }
  }
}
