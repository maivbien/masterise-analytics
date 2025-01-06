import 'package:flutter/material.dart';

import '../../utils/app_util.dart';
import '../data/analytics_performance_info.dart';

abstract class BaseAnalyticsWidget extends StatefulWidget {
  const BaseAnalyticsWidget({
    super.key,
    required this.child,
    required this.name,
    this.widgetName,
    this.parameters,
    this.pvId,
    this.trackPerformance = true,
    this.preLoadCallback,
    this.dataFetchCallback,
    this.performanceInfo,
  });
  final Widget child;
  final String name;
  final String? widgetName;
  final Map<String, String>? parameters;
  final String? pvId;
  final bool trackPerformance;
  final AnalyticsPerformanceInfo? performanceInfo;

  // Add network related callbacks
  final Future<void> Function()? preLoadCallback;
  final Future<void> Function()? dataFetchCallback;

  @override
  State<BaseAnalyticsWidget> createState() => _BaseAnalyticsWidgetState();
}

class _BaseAnalyticsWidgetState extends State<BaseAnalyticsWidget>
    with RouteAware {
  late final Stopwatch _totalStopwatch;
  late final Stopwatch _networkStopwatch;
  late final Stopwatch _serverStopwatch;
  // late final Stopwatch _transferStopwatch;
  late final Stopwatch _domProcessingStopwatch;
  late final Stopwatch _domCompletionStopwatch;

  final _customTimings = <String, Duration>{};
  final _metrics = <String, num>{};

  @override
  void initState() {
    super.initState();
    if (widget.trackPerformance) {
      _initializeStopwatches();
      _startTracking();
    }
  }

  void _initializeStopwatches() {
    _totalStopwatch = Stopwatch()..start();
    _networkStopwatch = Stopwatch();
    _serverStopwatch = Stopwatch();
    _domProcessingStopwatch = Stopwatch();
    _domCompletionStopwatch = Stopwatch();
  }

  Future<void> _startTracking() async {
    try {
      // Track network connection time
      _networkStopwatch.start();
      if (widget.preLoadCallback != null) {
        await widget.preLoadCallback!();
      }
      _networkStopwatch.stop();

      // Track server processing time
      _serverStopwatch.start();
      if (widget.dataFetchCallback != null) {
        await widget.dataFetchCallback!();
      }
      _serverStopwatch.stop();

      // Start DOM processing tracking
      _domProcessingStopwatch.start();
    } catch (e) {
      debugPrint('Error during performance tracking:', e);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.trackPerformance) {
      _domProcessingStopwatch.stop();
      addTiming('dependencies_loaded', _domProcessingStopwatch.elapsed);
    }
  }

  @override
  void dispose() {
    if (widget.trackPerformance) {
      _totalStopwatch.stop();
      // _createPerformanceInfo();
      onScreenEnd();
    }
    super.dispose();
  }

  // void _createPerformanceInfo() {
  //   performanceInfo = AnalyticsPerformanceInfo(
  //     screenName: widget.name,
  //     startTime: _initTime!,
  //     endTime: DateTime.now(),
  //     networkTime: _networkStopwatch.elapsed,
  //     serverTime: _serverStopwatch.elapsed,
  //     transferTime: _transferStopwatch.elapsed,
  //     domProcessingTime: _domProcessingStopwatch.elapsed,
  //     domCompletionTime: _domCompletionStopwatch.elapsed,
  //     onloadTime: _totalStopwatch.elapsed,
  //     customTimings: _customTimings,
  //     metrics: _metrics,
  //     attributes: {
  //       'widget_name': widget.widgetName ?? widget.name,
  //       ...?widget.parameters,
  //     },
  //   );
  // }

  void addTiming(String name, Duration duration) {
    if (widget.trackPerformance) {
      _customTimings[name] = duration;
    }
  }

  void addMetric(String name, num value) {
    if (widget.trackPerformance) {
      _metrics[name] = value;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.trackPerformance) {
      _domCompletionStopwatch.start();
      final result = widget.child;
      _domCompletionStopwatch.stop();
      addTiming('build_time', _domCompletionStopwatch.elapsed);
      return result;
    }
    return widget.child;
  }

  void onScreenStart() {
    // To be overridden by subclasses
  }

  void onScreenEnd() {
    // To be overridden by subclasses
  }
}
