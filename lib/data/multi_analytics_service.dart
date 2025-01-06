import 'package:flutter/foundation.dart';

import '../domain/analytics_event.dart';
import '../domain/analytics_screen.dart';
import '../domain/analytics_service.dart';
import '../domain/analytics_user.dart';

class MultiAnalyticsService implements AnalyticsService {
  MultiAnalyticsService({
    required List<AnalyticsService> services,
  }) : _services = services;
  final List<AnalyticsService> _services;

  @override
  String get providerName => 'multi_provider';

  @override
  Future<void> init() async {
    await Future.wait(
      _services.map((service) {
        return service.init().catchError((error) {
          debugPrint('Error initializing ${service.providerName}: $error');
          return Future.value(); // Continue with other services if one fails
        });
      }),
    );
  }

  @override
  Future<void> logScreen(AnalyticsScreen screen) async {
    await _executeForAllServices(
      (service) => service.logScreen(screen),
      'logScreen',
    );
  }

  @override
  Future<void> logEvent(AnalyticsEvent event) async {
    await _executeForAllServices(
      (service) => service.logEvent(event),
      'logEvent',
    );
  }

  @override
  Future<void> setUser(AnalyticsUser user) async {
    await _executeForAllServices(
      (service) => service.setUser(user),
      'setUser',
    );
  }

  @override
  Future<void> clearUser() async {
    await _executeForAllServices(
      (service) => service.clearUser(),
      'clearUser',
    );
  }

  @override
  Future<void> setUserProperty(String key, String value) async {
    await _executeForAllServices(
      (service) => service.setUserProperty(key, value),
      'setUserProperty',
    );
  }

  @override
  Future<void> logError(String message, {bool fatal = false}) async {
    await _executeForAllServices(
      (service) => service.logError(message, fatal: fatal),
      'logError',
    );
  }

  Future<void> _executeForAllServices(
    Future<void> Function(AnalyticsService service) action,
    String actionName,
  ) async {
    await Future.wait(
      _services.map((service) {
        return action(service).catchError((error) {
          debugPrint(
              'Error executing $actionName for ${service.providerName}: $error');
          return Future.value(); // Continue with other services if one fails
        });
      }),
    );
  }

  List<AnalyticsService> getProviders() => List.unmodifiable(_services);

  // Method to enable/disable specific providers
  void toggleProvider(String providerName, bool enabled) {
    final serviceIndex = _services.indexWhere(
      (service) => service.providerName == providerName,
    );
    if (serviceIndex != -1) {
      if (!enabled) {
        _services.removeAt(serviceIndex);
      }
    }
  }

  void addProvider(AnalyticsService service) {
    if (!_services.any((s) => s.providerName == service.providerName)) {
      _services.add(service);
    }
  }

  void removeProvider(String providerName) {
    _services.removeWhere((service) => service.providerName == providerName);
  }

  @override
  Future<void> logRenderWidget(String screen, int duration) async {
    await _executeForAllServices(
      (service) => service.logRenderWidget(screen, duration),
      'logRenderWidget',
    );
  }
}
