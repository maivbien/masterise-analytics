class AnalyticsDevice {
  AnalyticsDevice({
    this.deviceId,
    this.properties = const {},
  });
  final String? deviceId;
  final Map<String, dynamic> properties;
}
