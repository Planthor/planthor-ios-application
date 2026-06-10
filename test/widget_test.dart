import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:planthor_ios_application/main.dart';

void main() {
  testWidgets('app renders without error', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    expect(tester.takeException(), isNull);
  });
}
