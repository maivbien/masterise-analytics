import '../../utils/app_util.dart';
import '../analytics_manager.dart';

class AnalyticsProperty {
  static const String category = 'category';
  static const String itemName = 'item_name';
  static const String value = 'value';
  static const String startDate = 'start_date';
  static const String endDate = 'end_date';
  static const String status = 'status';
  static const String duration = 'duration';
}

class AnalyticsCategory {
  static const String general = 'general';
  static const String uiEvent = 'ui_event';
  static const String stateEvent = 'state_event';
  static const String dataEvent = 'data_event';
  static const String waringEvent = 'waring_event';
}

class AnalyticsEvent {
  const AnalyticsEvent({
    required this.action,
    this.parameters = const {},
  });

  final String action;
  final Map<String, Object> parameters;
}

class WrappedAnalyticsEvent {
  const WrappedAnalyticsEvent({
    required this.action,
    required this.category,
    this.name,
    this.screenName,
    this.value,
    this.startDate,
    this.endDate,
    this.isSuccess,
  });

  final String action;
  final String category;
  final String? name;
  final num? value;
  final String? screenName;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? isSuccess;

  int get duration => endDate!.difference(startDate!).inMilliseconds;

  AnalyticsEvent get toEvent {
    final eventName =
        isNullOrEmpty(screenName) ? action : '${screenName}_page_$action';
    final parameters = <String, Object>{
      AnalyticsProperty.category: category,
    };
    if (name != null) {
      parameters[AnalyticsProperty.itemName] = name!;
    }
    if (value != null) {
      parameters[AnalyticsProperty.value] = value!;
    }
    if (startDate != null) {
      parameters[AnalyticsProperty.startDate] = startDate!.toIso8601String();
    }
    if (endDate != null) {
      parameters[AnalyticsProperty.endDate] = endDate!.toIso8601String();
    }
    if (isSuccess != null) {
      parameters[AnalyticsProperty.status] = isSuccess! ? '1' : '0';
    }
    if (startDate != null && endDate != null) {
      parameters[AnalyticsProperty.duration] = duration.toString();
    }

    return AnalyticsEvent(
      action: eventName,
      parameters: parameters,
    );
  }

  @override
  String toString() {
    return 'WrappedAnalyticsEvent{action=$action, category=$category, screenName=$screenName, startDate=$startDate, endDate=$endDate, isSuccess=$isSuccess}';
  }
}

class UIEvent extends WrappedAnalyticsEvent {
  const UIEvent(String action, {super.name, super.value})
      : super(action: action, category: AnalyticsCategory.uiEvent);
}

class StateEvent extends WrappedAnalyticsEvent {
  const StateEvent(String action,
      {super.screenName,
      super.name,
      super.value,
      super.startDate,
      super.endDate,
      super.isSuccess})
      : super(action: action, category: AnalyticsCategory.stateEvent);

  factory StateEvent.start(String action, {String? name, num? value}) =>
      StateEvent(action, name: name, value: value, startDate: DateTime.now());

  StateEvent success() => copyWith(endDate: DateTime.now(), isSuccess: true);

  StateEvent failure() => copyWith(endDate: DateTime.now(), isSuccess: false);

  StateEvent copyWith({
    String? screenName,
    DateTime? startDate,
    DateTime? endDate,
    bool? isSuccess,
  }) {
    return StateEvent(
      action,
      screenName: screenName ?? this.screenName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class DataEvent extends WrappedAnalyticsEvent {
  const DataEvent(String action,
      {super.screenName,
      super.name,
      super.value,
      super.startDate,
      super.endDate,
      super.isSuccess})
      : super(action: action, category: AnalyticsCategory.dataEvent);

  factory DataEvent.start(String action, {String? name, num? value}) =>
      DataEvent(action, name: name, value: value, startDate: DateTime.now());

  DataEvent success() => copyWith(endDate: DateTime.now(), isSuccess: true);

  DataEvent failure() => copyWith(endDate: DateTime.now(), isSuccess: false);

  DataEvent copyWith({
    String? screenName,
    DateTime? startDate,
    DateTime? endDate,
    bool? isSuccess,
  }) {
    return DataEvent(
      action,
      screenName: screenName ?? this.screenName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class WarningEvent extends WrappedAnalyticsEvent {
  const WarningEvent(String action, {super.name, super.value})
      : super(action: action, category: AnalyticsCategory.waringEvent);
}

extension AnalyticsEventX on AnalyticsEvent {
  void log() {
    try {
      injector<AnalyticsManager>().logEvent(this);
    } catch (e, s) {
      debugPrint('AnalyticsEventX', e, s);
    }
  }
}

extension WrappedAnalyticsEventX on WrappedAnalyticsEvent {
  void log() => toEvent.log();
}
