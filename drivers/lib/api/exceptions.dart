import 'package:drivers/exceptions/common.dart';
import 'package:flutter/foundation.dart';

class ApiException implements Exception, DiagnosticMessageException {
  final int statusCode;
  final Object body;

  ApiException({@required this.statusCode, @required this.body})
      : assert(statusCode != null),
        assert(body != null);

  @override
  String get diagnosticMessage => 'Status code: $statusCode\nBody: $body';
}

class ApiUnauthorizedException extends ApiException {
  ApiUnauthorizedException({Object body}) : super(statusCode: 401, body: body);
}

class ApiPermissionDeniedException extends ApiException {
  ApiPermissionDeniedException({Object body})
      : super(statusCode: 403, body: body);
}

class ApiBadRequestException extends ApiException {
  ApiBadRequestException({Object body}) : super(statusCode: 400, body: body);
}

class ApiInternalServerException extends ApiException {
  ApiInternalServerException({Object body})
      : super(statusCode: 500, body: body);
}
