import 'performance_render.dart';

class BasePerformanceRender implements PerformanceRender {
  BasePerformanceRender(this.id);
  final String id;
  int? _startTime;
  final Map<String, dynamic> _attributes = {};
  final Map<String, num> _metrics = {};

  @override
  void start(String name, {Map<String, dynamic>? attributes}) {
    _startTime = DateTime.now().millisecondsSinceEpoch;
    if (attributes != null) {
      _attributes.addAll(attributes);
    }
  }

  @override
  void stop() {
    if (_startTime != null) {
      final duration = DateTime.now().millisecondsSinceEpoch - _startTime!;
      addMetric('duration', duration);
    }
  }

  @override
  void addAttribute(String key, String value) {
    _attributes[key] = value;
  }

  @override
  void addMetric(String name, num value) {
    _metrics[name] = value;
  }

  Map<String, dynamic> getAttributes() => Map.unmodifiable(_attributes);
  Map<String, num> getMetrics() => Map.unmodifiable(_metrics);
}
