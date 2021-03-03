import 'package:flutter/widgets.dart';

void logUiAction(String tag, String message, BuildContext context) {
  log(tag, context.describeOwnershipChain(message).toString());
}

void logError(
  String tag,
  String message, {
  Object exception,
  String traceParent,
}) {
  final tagError = '$tag ERROR';
  String logMessage = message;

  if (traceParent != null) {
    logMessage = '<$traceParent> $message';
  }

  log(tagError, logMessage);
}

void log(String tag, String message) {
  final logEntry = '[${tag.toUpperCase()}] $message';
  debugPrint(logEntry);
}
