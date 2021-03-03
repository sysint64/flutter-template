import 'package:localized_string/localized_string.dart';

class SchemeConsistencyException implements Exception {
  final String message;

  SchemeConsistencyException([this.message = 'Schemes consistency error']);

  @override
  String toString() {
    if (message == null) {
      return '$SchemeConsistencyException';
    }
    return '$SchemeConsistencyException: $message';
  }
}

abstract class DiagnosticMessageException implements Exception {
  String get diagnosticMessage;
}

abstract class LocalizeMessageException implements Exception {
  LocalizedString get localizedMessage;
}

abstract class LocalizeDescriptionException implements Exception {
  LocalizedString get descriptionMessage;
}

abstract class LogicException extends LocalizeMessageException {}

// ignore: avoid_positional_boolean_parameters
void require(bool invariant, Exception Function() exceptionFactory) {
  if (!invariant) {
    throw exceptionFactory();
  }
}

class CancelledException implements Exception {
}
