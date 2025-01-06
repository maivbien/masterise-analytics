import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

import '../../extensions/extensions.dart';
import '../../../utils/app_util.dart';
import '../../domain/analytics_event.dart';
import '../../domain/analytics_screen.dart';
import '../../domain/analytics_service.dart';
import '../../domain/analytics_user.dart';

class FirebaseAnalyticsService implements AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  @override
  Future<void> init() async {
    // Firebase Analytics is automatically initialized
  }
  @override
  String get providerName => 'firebase';
  @override
  Future<void> logScreen(AnalyticsScreen screen) async {
    try {
      await _analytics.logScreenView(
        screenName: screen.screenName,
        parameters: screen.dimensions,
      );
    } catch (e) {
      debugPrint('Error tracking screen in Firebase: $e');
    }
  }

  @override
  Future<void> logEvent(AnalyticsEvent event) async {
    try {
      await _analytics.logEvent(
        name: event.action.limitChars(40),
        parameters: event.parameters,
      );
    } catch (e) {
      debugPrint('Error tracking event in Firebase: $e');
    }
  }

  @override
  Future<void> setUser(AnalyticsUser user) async {
    try {
      if (user.id != null) {
        await _analytics.setUserId(id: user.id);
      }

      for (var entry in user.properties.entries) {
        await setUserProperty(entry.key, entry.value.toString());
      }
    } catch (e) {
      debugPrint('Error setting user in Firebase: $e');
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      await _analytics.setUserId(id: null);
    } catch (e) {
      debugPrint('Error clearing user in Firebase: $e');
    }
  }

  @override
  Future<void> setUserProperty(String key, String value) async {
    try {
      await _analytics.setUserProperty(name: key, value: value);
    } catch (e) {
      debugPrint('Error setting user property in Firebase: $e');
    }
  }

  Future<void> logInfo(String message, {bool fatal = false}) async {
    try {
      await _analytics.logEvent(
        name: 'error',
        parameters: {
          'message': message,
          'fatal': fatal,
        },
      );
    } catch (e) {
      debugPrint('Error logging error in Firebase: $e');
    }
  }

  @override
  Future<void> logRenderWidget(String screen, int duration) async {
    try {
      await _analytics.logScreenView(
          screenName: screen, parameters: {'duration': duration});
    } catch (e) {
      debugPrint('Error tracking screen in Firebase: $e');
    }
  }

  @override
  Future<void> logError(String message, {bool fatal = false}) async {}
}
