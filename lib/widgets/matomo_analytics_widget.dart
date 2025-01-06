import 'package:flutter/material.dart';
import 'package:matomo_tracker/matomo_tracker.dart';

import 'base_analytics_widget.dart';

class MatomoAnalyticsWidget extends BaseAnalyticsWidget {
  const MatomoAnalyticsWidget({
    super.key,
    required super.child,
    required super.name,
    super.widgetName,
    super.parameters,
    super.pvId,
    super.performanceInfo,
  });

  @override
  State<MatomoAnalyticsWidget> createState() => _MatomoAnalyticsWidgetState();
}

class _MatomoAnalyticsWidgetState extends State<MatomoAnalyticsWidget> {
  void onScreenStart() {}

  void onScreenEnd() {
    // if (_screenStartTime != null) {
    //   final duration = DateTime.now().difference(_screenStartTime!);
    //   FlutterMatomo.trackEvent(
    //     'Screen Duration',
    //     'View',
    //     name: widget.screenName,
    //     value: duration.inSeconds,
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return TraceableWidget(
      // screenName: widget.name,
      actionName: widget.name,
      dimensions: widget.parameters,
      pvId: widget.pvId,
      performanceInfo: PerformanceInfo(
        networkTime: widget.performanceInfo?.networkTime,
        serverTime: widget.performanceInfo?.serverTime,
        transferTime: widget.performanceInfo?.transferTime,
        domProcessingTime: widget.performanceInfo?.domProcessingTime,
        domCompletionTime: widget.performanceInfo?.domCompletionTime,
        onloadTime: widget.performanceInfo?.onloadTime,
      ),
      child: widget.child,
    );
  }
}
