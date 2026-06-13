// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strava_connection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$stravaConnectionHash() => r'a8ef261a2e2930a496f099bfa93d991f0e14f286';

/// Manages Strava connection state.
///
/// Currently stubbed with a simulated delay. Replace the body of
/// [connect] / [disconnect] with real OAuth + backend calls when ready.
///
/// Copied from [StravaConnection].
@ProviderFor(StravaConnection)
final stravaConnectionProvider =
    AutoDisposeNotifierProvider<
      StravaConnection,
      StravaConnectionStatus
    >.internal(
      StravaConnection.new,
      name: r'stravaConnectionProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$stravaConnectionHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$StravaConnection = AutoDisposeNotifier<StravaConnectionStatus>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
