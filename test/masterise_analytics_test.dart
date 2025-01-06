import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'package:masterise_analytics/masterise_analytics.dart';

void main() {
  test('adds one to input values', () async {
    setupDependencies();
  });
}

void setupDependencies() async {
  final getIt = GetIt.instance;

  await registerAnalyticsService(getIt, 'matomoUrl', 'siteId');
}
