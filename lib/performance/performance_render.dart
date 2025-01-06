abstract class PerformanceRender {
  void start(String name, {Map<String, dynamic>? attributes});
  void stop();
  void addAttribute(String key, String value);
  void addMetric(String name, num value);
}
