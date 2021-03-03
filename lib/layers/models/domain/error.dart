import 'package:drivers/exceptions/common.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_template/git_revision.dart';
import 'package:localized_string/localized_string.dart';
import 'package:optional/optional.dart';
import 'package:drivers/exceptions/show.dart';

class AppError {
  final Object e;
  final StackTrace stackTrace;

  const AppError(this.e, this.stackTrace);

  LocalizedString get title => showExceptionMessage(e);

  Optional<LocalizedString> get description {
    if (e is LocalizeDescriptionException) {
      return Optional.of(
        (e as LocalizeDescriptionException).descriptionMessage,
      );
    } else {
      return const Optional.empty();
    }
  }

  String getReport(BuildContext context) {
    if (e is String) {
      return 'GIT_REVISION: $gitRevision\n\n'
          '$e';
    } else {
      if (e is DiagnosticMessageException) {
        final diagnosticMessage = (e as DiagnosticMessageException).diagnosticMessage;
        final message = title.localize(context);

        return 'GIT_REVISION: $gitRevision\n\n'
            'MESSAGE: $message\n'
            'ERROR: ${e.runtimeType}\n\n'
            'DIAGNOSTIC:\n'
            '$diagnosticMessage';
      } else {
        return 'GIT_REVISION: $gitRevision\n\n'
            'ERROR: ${e.runtimeType}\n'
            '$e\n';
      }
    }
  }

  String getReportWithStackTrace(BuildContext context) {
    if (stackTrace != null) {
      return '${getReport(context)}\n\n'
          'STACK TRACE\n\n'
          '$stackTrace';
    } else {
      return getReport(context);
    }
  }
}
