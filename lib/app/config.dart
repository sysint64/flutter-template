import 'package:flutter/material.dart';

class ConfigField<T> {
  final String title;
  final T value;

  ConfigField(this.title, this.value);
}

class Config {
  final String configName;
  final String apiBaseUrl;
  final bool apiLogging;
  final bool debugServices;
  final bool reportCrashes;

  // Add here new fields to show them in debug services screen
  List<ConfigField> get fields => [
        ConfigField('Config name', configName),
        ConfigField('API Endpoint', apiBaseUrl),
        ConfigField('API Logging', apiLogging),
        ConfigField('Debug Services', debugServices),
        ConfigField('Report Crashed', reportCrashes),
      ];

  Config({
    @required this.configName,
    @required this.apiBaseUrl,
    @required this.apiLogging,
    @required this.debugServices,
    @required this.reportCrashes,
  })  : assert(configName != null),
        assert(apiBaseUrl != null),
        assert(apiLogging != null),
        assert(debugServices != null),
        assert(reportCrashes != null);

  Config copyWith({
    String configName,
    String apiBaseUrl,
    bool apiLogging,
    bool debugWithAlice,
    bool debugServices,
    bool reportCrashes,
  }) {
    return Config(
      configName: configName ?? this.configName,
      apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
      apiLogging: apiLogging ?? this.apiLogging,
      debugServices: debugServices ?? this.debugServices,
      reportCrashes: reportCrashes ?? this.reportCrashes,
    );
  }
}

class AppConfig extends InheritedWidget {
  final Config config;

  const AppConfig({
    @required this.config,
    @required Widget child,
  })  : assert(config != null),
        super(child: child);

  static AppConfig of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
