import 'package:flutter/material.dart';

import 'base_analytics_widget.dart';

class FirebaseAnalyticsWidget extends BaseAnalyticsWidget {
  const FirebaseAnalyticsWidget({
    super.key,
    required super.child,
    required super.name,
    super.widgetName,
    super.parameters,
    super.pvId,
  });

  @override
  State<FirebaseAnalyticsWidget> createState() =>
      _FirebaseAnalyticsWidgetState();
}

class _FirebaseAnalyticsWidgetState extends State<FirebaseAnalyticsWidget> {
  void onScreenStart() async {}

  void onScreenEnd() async {
    //   if (_screenStartTime != null) {
    //     final duration = DateTime.now().difference(_screenStartTime!);
    //     await FirebaseAnalytics.instance.logEvent(
    //       name: 'screen_duration',
    //       parameters: {
    //         'screen_name': widget.screenName,
    //         'duration_seconds': duration.inSeconds,
    //         if (widget.parameters != null) ...widget.parameters!,
    //       },
    //     );
    //   }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
