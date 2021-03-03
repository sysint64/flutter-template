import 'package:flutter_template/app/config.dart';
import 'package:flutter_template/layers/di/modules/services/domain.dart';
import 'package:flutter_template/layers/di/modules/services/session.dart';
import 'package:get_it/get_it.dart';
import 'package:drivers/dependencies.dart';

import 'services/api.dart';

Future<void> setupServicesDependencies(Config config) async {
  final sl = GetIt.instance;

  await setupApiDependencies(config);
  await setupDomainDependencies(config);
  await setupSessionDependencies(config);
}
