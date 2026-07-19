import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planthor_ios_application/features/navigation/presentation/navigation_provider.dart';

void main() {
  group('NavigationProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() => container.dispose());

    test('initial state is 0', () {
      expect(container.read(navigationProvider), 0);
    });

    test('setIndex updates state', () {
      container.read(navigationProvider.notifier).setIndex(2);
      expect(container.read(navigationProvider), 2);
    });

    test('setIndex to 0 from 2', () {
      container.read(navigationProvider.notifier).setIndex(2);
      container.read(navigationProvider.notifier).setIndex(0);
      expect(container.read(navigationProvider), 0);
    });
  });
}
