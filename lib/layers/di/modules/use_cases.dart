import 'package:flutter_template/app/config.dart';
import 'package:flutter_template/layers/use_cases/app.dart';
import 'package:flutter_template/layers/use_cases/impl/app.dart';
import 'package:get_it/get_it.dart';

Future<void> setupUseCasesDependencies(Config config) async {
  final sl = GetIt.instance;

  sl.registerFactory<AppUseCase>(
    () => AppUseCaseImpl(),
  );
}
