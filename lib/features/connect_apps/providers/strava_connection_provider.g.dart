// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strava_connection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$stravaConnectionHash() => r'850e7e23acd5d32519040551d5f8731c9ffa9fcb';

/// Manages Strava connection state.
///
/// Copied from [StravaConnection].
@ProviderFor(StravaConnection)
final stravaConnectionProvider =
    AutoDisposeAsyncNotifierProvider<
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

typedef _$StravaConnection = AutoDisposeAsyncNotifier<StravaConnectionStatus>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
