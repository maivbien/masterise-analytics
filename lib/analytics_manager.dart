import 'data/multi_analytics_service.dart';
import 'domain/analytics_event.dart';
import 'domain/analytics_screen.dart';
import 'domain/analytics_service.dart';
import 'domain/analytics_user.dart';

class AnalyticsManager {
  // AnalyticsManager()
  //     : _multiAnalyticsService = injector<MultiAnalyticsService>();
  final MultiAnalyticsService _multiAnalyticsService;

  AnalyticsManager({required MultiAnalyticsService multiAnalyticsService})
      : _multiAnalyticsService = multiAnalyticsService;

  void enableProvider(String providerName) {
    _multiAnalyticsService.toggleProvider(providerName, true);
  }

  void disableProvider(String providerName) {
    _multiAnalyticsService.toggleProvider(providerName, false);
  }

  void addProvider(AnalyticsService service) {
    _multiAnalyticsService.addProvider(service);
  }

  Future<void> trackWithSpecificProvider(
    String providerName,
    AnalyticsEvent event,
  ) async {
    // Get the specific provider from MultiAnalyticsService
    final services = _multiAnalyticsService.getProviders();
    final provider = services.firstWhere(
      (service) => service.providerName == providerName,
      orElse: () => throw Exception('Provider not found: $providerName'),
    );

    await provider.logEvent(event);
  }

  Future<void> logEvent(AnalyticsEvent event) async {
    await _multiAnalyticsService.logEvent(event);
  }

  Future<void> logScreen(AnalyticsScreen screen) async {
    await _multiAnalyticsService.logScreen(screen);
  }

  Future<void> logRenderWidget(String screen, int duration) async {
    await _multiAnalyticsService.logRenderWidget(screen, duration);
  }

  Future<void> setUser(AnalyticsUser user) async {
    await _multiAnalyticsService.setUser(user);
  }
}
