import 'package:flutter_test/flutter_test.dart';
import 'package:planthor_ios_application/features/plans/bloc/personal_plans_provider.dart';

void main() {
  group('parsePersonalPlansResponse', () {
    test('parses cursor-paginated API response', () {
      final plans = parsePersonalPlansResponse({
        'items': [
          {
            'planId': 'plan-1',
            'planName': 'Run 100 km',
            'unit': 'km',
            'target': 100,
            'currentValue': 25,
            'status': 'PLANNED',
          },
        ],
        'nextCursor': null,
        'hasNextPage': false,
      });

      expect(plans, hasLength(1));
      expect(plans.single.id, 'plan-1');
      expect(plans.single.name, 'Run 100 km');
      expect(plans.single.progress, 0.25);
    });

    test('keeps compatibility with legacy list response', () {
      final plans = parsePersonalPlansResponse(<Object?>[]);

      expect(plans, isEmpty);
    });

    test('rejects malformed response', () {
      expect(
        () => parsePersonalPlansResponse({'items': 'not-a-list'}),
        throwsFormatException,
      );
    });
  });
}
