import 'package:flutter/material.dart';

import '../analytics_manager.dart';
import '../data/analytics_performance_info.dart';
import 'firebase_analytics_widget.dart';
import 'matomo_analytics_widget.dart';

class MultiAnalyticsWidget extends StatelessWidget {
  const MultiAnalyticsWidget({
    super.key,
    required this.child,
    required this.name,
    this.widgetName,
    this.dimesions,
    this.pvId,
    this.useMatomoTracker = true,
    this.useFirebaseTracker = true,
    this.performanceInfo,
    required this.analyticsManager,
  });
  final Widget child;
  final String name;
  final String? widgetName;
  final Map<String, String>? dimesions;
  final String? pvId;
  final bool useMatomoTracker;
  final bool useFirebaseTracker;
  final AnalyticsPerformanceInfo? performanceInfo;
  final AnalyticsManager analyticsManager;

  @override
  Widget build(BuildContext context) {
    Widget currentChild = child;

    if (useFirebaseTracker) {
      currentChild = FirebaseAnalyticsWidget(
        name: name,
        widgetName: widgetName,
        parameters: dimesions,
        pvId: pvId,
        child: currentChild,
        // performanceInfo: performanceInfo,
      );
    }

    if (useMatomoTracker) {
      currentChild = MatomoAnalyticsWidget(
        name: name,
        widgetName: widgetName,
        parameters: dimesions,
        pvId: pvId,
        performanceInfo: performanceInfo,
        child: currentChild,
      );
    }

    return currentChild;
  }
}
