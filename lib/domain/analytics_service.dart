import 'analytics_event.dart';
import 'analytics_screen.dart';
import 'analytics_user.dart';

abstract class AnalyticsService {
  String get providerName; //
  Future<void> init();
  Future<void> logScreen(AnalyticsScreen screen);
  Future<void> logEvent(AnalyticsEvent event);
  Future<void> setUser(AnalyticsUser user);
  Future<void> clearUser();
  Future<void> setUserProperty(String key, String value);
  Future<void> logError(String message, {bool fatal = false});
  Future<void> logRenderWidget(String screen, int duration);
}
