import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../analytics_manager.dart';
import '../domain/analytics_screen.dart';

class AnalyticsTraceableWidget extends StatefulWidget {
  const AnalyticsTraceableWidget({
    super.key,
    required this.child,
    this.name,
    this.dimensions,
    this.actionName,
    required this.analyticsManager,
    this.trackRenderWidget = false,
    this.onDataReady,
  });
  final Widget child;
  final String? name;
  final String? actionName;
  final bool? trackRenderWidget;

  final Map<String, String>? dimensions;
  final AnalyticsManager analyticsManager;
  final Future<void> Function()? onDataReady;

  @override
  State<AnalyticsTraceableWidget> createState() =>
      _AnalyticsTraceableWidgetState();
}

class _AnalyticsTraceableWidgetState extends State<AnalyticsTraceableWidget>
    with RouteAware {
  int? _screenStartTime;
  bool _hasTrackedDuration = false;

  @override
  void initState() {
    super.initState();
    _screenStartTime = DateTime.now().millisecondsSinceEpoch;

    _trackScreenView();

    if (widget.trackRenderWidget ?? false) {
      _setupTrackingRenderWidget();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _trackScreenView() async {
    await widget.analyticsManager
        .logScreen(AnalyticsScreen(screenName: widget.name ?? '', dimensions: {
      ...?widget.dimensions,
    }));
  }

  void _trackScreenDuration() {
    if (_screenStartTime != null) {
      final duration =
          DateTime.now().millisecondsSinceEpoch - _screenStartTime!;

      // final dimensions = {
      //   'duration_seconds': duration.toString(),
      //   ...?widget.dimensions,
      // };

      // widget.analyticsManager.logScreen(AnalyticsScreen(
      //     screenName: widget.name ?? '', parameters: dimensions));
      widget.analyticsManager.logRenderWidget(widget.name ?? '', duration);
    }
  }

  void _setupTrackingRenderWidget() {
    if (widget.onDataReady != null) {
      // Data is ready
      widget.onDataReady!().then((_) {
        if (!_hasTrackedDuration && mounted) {
          _trackScreenDuration();
          _hasTrackedDuration = true;
        }
      });
    } else {
      // First frame rendered
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!_hasTrackedDuration && mounted) {
          _trackScreenDuration();
          _hasTrackedDuration = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.trackMatomo) {
    //   return TraceableWidget(
    //     screenName: widget.screenName,
    //     widgetName: widget.widgetName,
    //     dimensions: widget.dimensions,
    //     pvId: widget.pvId,
    //     child: widget.child,
    //   );
    // }
    return widget.child;
  }
}
