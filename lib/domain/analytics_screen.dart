class AnalyticsScreen {
  AnalyticsScreen({
    required this.screenName,
    this.dimensions,
    this.path,
  });
  final String screenName;
  final String? path;
  final Map<String, String>? dimensions;
}
