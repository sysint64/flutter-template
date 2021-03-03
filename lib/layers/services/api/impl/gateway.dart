import 'package:drivers/api/dio_client.dart';
import 'package:flutter_template/layers/services/api/gateway.dart';

class ApiGatewayImpl implements ApiGateway {
  final DioClient _client;

  ApiGatewayImpl(this._client);
}
