library;

import 'package:get_it/get_it.dart';
import 'data/firebase/firebase_analytics_service.dart';
import 'data/matomo/matomo_analytics_service.dart';
import 'data/multi_analytics_service.dart';
import 'analytics_manager.dart';

Future<void> registerAnalyticsService(
  GetIt injector,
  String matomoUrl,
  String siteId,
) async {
  if (!injector.isRegistered<MatomoAnalyticsService>()) {
    injector.registerLazySingleton<MatomoAnalyticsService>(
      () => MatomoAnalyticsService(
        matomoUrl: matomoUrl,
        siteId: siteId,
      ),
    );
  }

  if (!injector.isRegistered<FirebaseAnalyticsService>()) {
    injector.registerLazySingleton<FirebaseAnalyticsService>(
      () => FirebaseAnalyticsService(),
    );
  }

  if (!injector.isRegistered<MultiAnalyticsService>()) {
    injector.registerLazySingleton<MultiAnalyticsService>(
      () => MultiAnalyticsService(
        services: [
          injector<MatomoAnalyticsService>(),
          injector<FirebaseAnalyticsService>(),
        ],
      ),
    );
  }

  if (!injector.isRegistered<AnalyticsManager>()) {
    injector.registerLazySingleton<AnalyticsManager>(
      () => AnalyticsManager(
          multiAnalyticsService: injector<MultiAnalyticsService>()),
    );
  }

  await injector<MultiAnalyticsService>().init();
}
