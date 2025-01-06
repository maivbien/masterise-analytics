import 'package:matomo_tracker/matomo_tracker.dart';

import '../../../extensions/extensions.dart';
import '../../../utils/app_util.dart';
import '../../domain/analytics_event.dart';
import '../../domain/analytics_screen.dart';
import '../../domain/analytics_service.dart';
import '../../domain/analytics_user.dart';

class MatomoAnalyticsService implements AnalyticsService {
  MatomoAnalyticsService({
    required this.matomoUrl,
    required this.siteId,
    this.visitorId,
  });

  final String matomoUrl;
  final String siteId;
  final String? visitorId;

  @override
  String get providerName => 'matomo';

  @override
  Future<void> init() async {
    try {
      await MatomoTracker.instance.initialize(
        url: matomoUrl,
        siteId: siteId,
        visitorId: visitorId,
      );
      // await MatomoTracker.trackAppDownload();
      await MatomoTracker.instance.setOptOut(optOut: false);
    } catch (e, s) {
      debugPrint('matomo_analytics_service.dart -> init', e, s);
    }
  }

  @override
  Future<void> logScreen(AnalyticsScreen screen) async {
    try {
      MatomoTracker.instance.trackPageViewWithName(
        actionName: screen.screenName,
        path: screen.path,
        dimensions: screen.dimensions,
      );
    } catch (e, s) {
      debugPrint('matomo_analytics_service.dart -> logScreen', e, s);
    }
  }

  /// Parameters - Dimensions mapping:
  /// - dimension1: start_date (DateTime in ISO-8601 format)
  /// - dimension2: end_date (DateTime in ISO-8601 format)
  /// - dimension3: status (1: success, 0: failure)
  /// - dimension4: duration (in milliseconds)
  (EventInfo, Map<String, String>?) _fromAnalyticsEvent(AnalyticsEvent event) {
    final params = event.parameters;
    final dimensions = <String, String>{};
    final notDimensions = {
      AnalyticsProperty.category,
      AnalyticsProperty.itemName,
      AnalyticsProperty.value,
    };
    params.forEach((key, value) {
      if (!notDimensions.contains(key) && isNotNullOrEmpty(value)) {
        switch (key) {
          case AnalyticsProperty.startDate:
            dimensions['dimension1'] = value as String;
            break;
          case AnalyticsProperty.endDate:
            dimensions['dimension2'] = value as String;
            break;
          case AnalyticsProperty.status:
            dimensions['dimension3'] = value as String;
            break;
          case AnalyticsProperty.duration:
            dimensions['dimension4'] = value as String;
            break;
        }
      }
    });
    final category = (params[AnalyticsProperty.category] as String?) ??
        AnalyticsCategory.general;
    final name = params[AnalyticsProperty.itemName] as String?;
    final value = params[AnalyticsProperty.value] as num?;

    return (
      EventInfo(
        category: category.limitChars(255),
        action: event.action.limitChars(255),
        name: name?.limitChars(255),
        value: value,
      ),
      dimensions.isEmpty ? null : dimensions,
    );
  }

  @override
  Future<void> logEvent(AnalyticsEvent event) async {
    try {
      final model = _fromAnalyticsEvent(event);
      MatomoTracker.instance.trackEvent(
        eventInfo: model.$1,
        dimensions: model.$2,
      );
    } catch (e, s) {
      debugPrint('matomo_analytics_service.dart -> logEvent', e, s);
    }
  }

  @override
  Future<void> logRenderWidget(String widgetName, int duration) async {
    try {
      MatomoTracker.instance.trackPageViewWithName(
        actionName: widgetName,
        performanceInfo:
            PerformanceInfo(onloadTime: Duration(milliseconds: duration)),
      );
    } catch (e, s) {
      debugPrint('matomo_analytics_service.dart -> logRenderWidget', e, s);
    }
  }

  @override
  Future<void> setUser(AnalyticsUser user) async {
    try {
      if (user.id != null) {
        MatomoTracker.instance.setVisitorUserId(user.id);
      }

      for (var entry in user.properties.entries) {
        await setUserProperty(entry.key, entry.value.toString());
      }
    } catch (e, s) {
      debugPrint('matomo_analytics_service.dart -> setUser', e, s);
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      MatomoTracker.instance.setVisitorUserId('');
    } catch (e, s) {
      debugPrint('matomo_analytics_service.dart -> clearUser', e, s);
    }
  }

  @override
  Future<void> setUserProperty(String key, String value) async {
    try {
      // In Matomo, custom dimensions for user properties
      MatomoTracker.instance.trackDimensions(
        dimensions: {
          'dimension${_getDimensionId(key)}': value,
        },
      );
    } catch (e, s) {
      debugPrint('Error setting user property in Matomo:', e, s);
    }
  }

  @override
  Future<void> logError(String message, {bool fatal = false}) async {
    // try {
    //   await MatomoTracker.instance.trackException(
    //     description: message,
    //     fatal: fatal,
    //   );
    // } catch (e) {
    //   print('Error logging error in Matomo: $e');
    // }
  }

  // Helper method to map property keys to dimension IDs
  int _getDimensionId(String key) {
    // Define your mapping here based on Matomo configuration
    final Map<String, int> dimensionMap = {
      'app_version': 5,
      'device_id': 6,
      'device_lang': 7,
      'app_setting_lang': 8,
      'device_theme': 9,
      'app_setting_theme': 10,
      'device_time_zone': 11,
      // Add more mappings here
    };
    return dimensionMap[key] ?? 1;
  }
}
