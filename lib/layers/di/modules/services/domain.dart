import 'package:flutter_template/app/config.dart';
import 'package:flutter_template/layers/services/errors.dart';
import 'package:get_it/get_it.dart';

Future<void> setupDomainDependencies(Config config) async {
  final sl = GetIt.instance;

  sl.registerLazySingleton<ErrorsService>(
    () => ErrorsService(),
  );
}
