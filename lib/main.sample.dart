import 'package:flutter/widgets.dart';
import 'package:flutter_template/app/app.dart';
import 'package:flutter_template/app/config.dart';
import 'package:flutter_template/app/configs.dart';

Future<void> main() async {
  final config = devConfig();
  final configuredApp = AppConfig(
    config: config,
    child: MyApp(
      home: SplashScreenProvider(),
    ),
  );

  await setUp(config);
  await setupDependencies(config);

  runApp(configuredApp);
}
