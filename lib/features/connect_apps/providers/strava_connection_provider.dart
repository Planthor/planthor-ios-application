import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'strava_connection_provider.g.dart';

/// Connection status for external app integrations.
enum StravaConnectionStatus { disconnected, connecting, connected }

/// Manages Strava connection state.
///
/// Currently stubbed with a simulated delay. Replace the body of
/// [connect] / [disconnect] with real OAuth + backend calls when ready.
@riverpod
class StravaConnection extends _$StravaConnection {
  @override
  StravaConnectionStatus build() {
    return StravaConnectionStatus.disconnected;
  }

  /// Initiates Strava OAuth connection.
  ///
  /// TODO: Replace stub with real Strava OAuth flow:
  ///   1. Open Strava authorize URL via flutter_appauth
  ///   2. Exchange code with backend (POST /api/strava/connect)
  ///   3. Persist connection status
  Future<void> connect() async {
    state = StravaConnectionStatus.connecting;
    try {
      // Simulated delay — replace with actual API call.
      await Future<void>.delayed(const Duration(seconds: 2));
      state = StravaConnectionStatus.connected;
    } catch (_) {
      state = StravaConnectionStatus.disconnected;
    }
  }

  /// Disconnects Strava integration.
  ///
  /// TODO: Call backend (DELETE /api/strava/disconnect) and revoke tokens.
  Future<void> disconnect() async {
    state = StravaConnectionStatus.disconnected;
  }
}
