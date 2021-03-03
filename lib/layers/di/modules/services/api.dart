import 'package:flutter_template/app/config.dart';
import 'package:flutter_template/layers/services/api/gateway.dart';
import 'package:flutter_template/layers/services/api/impl/gateway.dart';
import 'package:get_it/get_it.dart';
import 'package:drivers/api/dio_client.dart';
import 'package:drivers/dependencies.dart';

Future<void> setupApiDependencies(Config config) async {
  final sl = GetIt.instance;

  sl.registerLazySingleton<ApiGateway>(
    () => ApiGatewayImpl(
      resolveDependency<DioClient>(),
    ),
  );
}
