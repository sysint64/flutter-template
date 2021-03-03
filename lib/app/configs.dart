import 'package:flutter_template/app/config.dart';

Config devConfig() => Config(
      configName: 'DEV',
      apiBaseUrl: 'localhost',
      apiLogging: true,
      debugServices: true,
      reportCrashes: false,
    );
