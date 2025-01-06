

Masterise Analytics
Masterise Analytics Package is a Flutter package that provides a unified analytics solution by integrating multiple analytics services such as Firebase Analytics and Matomo. It leverages the GetIt service locator for dependency injection, making it easy to manage and utilize analytics services across your Flutter application.

## Features

Multi-Analytics Support: Seamlessly integrates with Firebase Analytics and Matomo.
Service Locator: Utilizes GetIt for efficient dependency management.
Extensible: Easily add more analytics services in the future.

## Installation

Add to `pubspec.yaml`:

```yaml
dependencies:
  masterise_analytics:
    git:
      url: https://github.com/maivbien/masterise-analytics.git
      ref: main

```

## Setup

```dart matomo setup
void setupDependencies() async {
  final getIt = GetIt.instance;

    matomoUrl: 'https://matomo.example.com',
    siteId: '12345',

  await registerAnalyticsService(getIt, matomoUrl, sideId);
}
```
## Usage

1. Define an Analytics Event
Create an instance of AnalyticsEvent with the necessary details.

```dart
import 'package:analytics_package/analytics_event.dart';

final event = AnalyticsEvent(
  screenName: 'HomeScreen',
  dimensions: {'user_id': '12345', 'feature': 'login'},
);
```


## Additional information
```dart getDimensionId on matomo
int _getDimensionId(String key) {
    // Define your mapping here based on Matomo configuration
    final Map<String, int> dimensionMap = {
      'app_version': 5,
      'device_id': 6,
      'device_lang': 7,
      'app_setting_lang': 8,
      'device_theme': 9,
      'app_setting_theme': 10,
      'device_time_zone': 11,
    };
    return dimensionMap[key] ?? 1;
  }
  ```

# masterise-analytics
