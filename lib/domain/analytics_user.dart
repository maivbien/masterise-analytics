class AnalyticsUser {
  AnalyticsUser({
    this.id,
    this.properties = const {},
  });
  final String? id;
  final Map<String, dynamic> properties;
}
