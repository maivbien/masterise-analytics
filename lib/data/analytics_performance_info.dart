class AnalyticsPerformanceInfo {
  AnalyticsPerformanceInfo({
    required this.screenName,
    required this.startTime,
    this.endTime,
    this.networkTime,
    this.serverTime,
    this.transferTime,
    this.domProcessingTime,
    this.domCompletionTime,
    this.onloadTime,
    Map<String, Duration>? customTimings,
    Map<String, num>? metrics,
    Map<String, String>? attributes,
  })  : customTimings = customTimings ?? {},
        metrics = metrics ?? {},
        attributes = attributes ?? {};
  final String screenName;
  final DateTime startTime;
  final DateTime? endTime;

  // Network metrics
  final Duration? networkTime; // Time to establish network connection
  final Duration? serverTime; // Server processing time
  final Duration? transferTime; // Data transfer time

  // Processing metrics
  final Duration? domProcessingTime; // Time to process widget tree
  final Duration? domCompletionTime; // Time to complete widget rendering
  final Duration? onloadTime; // Total time until fully loaded

  // Additional metrics
  final Map<String, Duration> customTimings;
  final Map<String, num> metrics;
  final Map<String, String> attributes;

  int get totalDurationInMilliseconds {
    return endTime?.difference(startTime).inMilliseconds ?? 0;
  }

  Map<String, dynamic> toJson() => {
        'screen_name': screenName,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime?.toIso8601String(),
        'total_duration_ms': totalDurationInMilliseconds,
        'network_time_ms': networkTime?.inMilliseconds,
        'server_time_ms': serverTime?.inMilliseconds,
        'transfer_time_ms': transferTime?.inMilliseconds,
        'dom_processing_time_ms': domProcessingTime?.inMilliseconds,
        'dom_completion_time_ms': domCompletionTime?.inMilliseconds,
        'onload_time_ms': onloadTime?.inMilliseconds,
        'custom_timings':
            customTimings.map((k, v) => MapEntry(k, v.inMilliseconds)),
        'metrics': metrics,
        'attributes': attributes,
      };
}
