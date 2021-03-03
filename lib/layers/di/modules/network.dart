import 'package:alice/alice.dart';
import 'package:dio/dio.dart';
import 'package:flutter_template/app/config.dart';
import 'package:get_it/get_it.dart';
import 'package:drivers/api/dio_client.dart';
import 'package:drivers/dependencies.dart';

Future<void> setupNetworkDependencies(Config config) async {
  final sl = GetIt.instance;

  if (config.apiLogging) {
    final alice = Alice(
      showNotification: true,
      darkTheme: true,
    );

    sl.registerSingleton(alice);
  }

  sl.registerFactory<Dio>(
    () => _createDio(config),
  );

  sl.registerFactory<DioClient>(
    () => DioClient(
      resolveDependency<Dio>(),
      baseEndpoint: config.apiBaseUrl,
    ),
  );
}

Dio _createDio(Config config) {
  final dio = Dio();

  if (config.apiLogging) {
    final alice = resolveDependency<Alice>();
    dio.interceptors.add(alice.getDioInterceptor());

    dio.interceptors.add(
      LogInterceptor(
        requestHeader: true,
        responseHeader: true,
        requestBody: true,
        responseBody: true,
      ),
    );
  }

  return dio;
}
